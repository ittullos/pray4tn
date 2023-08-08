require 'aws-record'
require_relative 'route'

class Checkpoint
  include Aws::Record
  set_table_name ENV["CHECKPOINT_TABLE_NAME"]

  string_attr  :user_id,   hash_key: true
  integer_attr :recorded_at, range_key: true
  integer_attr :route_id
  string_attr  :lat
  string_attr  :long
  string_attr  :type
  string_attr  :match_key
  
  class << self
    def end_route(checkpoint)
      new_checkpoint(lat:       checkpoint.lat,
                     long:      checkpoint.long,
                     type:      "stop",
                     user_id:    checkpoint.user_id)
    end

    def close_last_route(user_id)
      puts "CHECKPOINT#clost_last_route"
      checkpoint = last_checkpoint(user_id)
      puts "CHECKPOINT#close_last_route:checkpoint:#{checkpoint}"
      if checkpoint && checkpoint.type != "stop"
        end_route(checkpoint) if checkpoint.route_id
      end
    end

    def current_route_id(user_id)
      last_start_checkpoint = user_checkpoints(user_id).start_points.most_recent
      if last_start_checkpoint
        Route[last_start_checkpoint.route_id].is_closed? ? nil : last_start_checkpoint.route_id
      else
        nil
      end
    end

    def current_route(user_id)
      last_start_checkpoint = Checkpoint.last_user_checkpoint(user_id, "start")
      if last_start_checkpoint && !last_start_checkpoint.route_id.nil?
        last_route = Route.find(id: last_start_checkpoint.route_id)
        last_route.is_closed? ? nil : last_route
      else
        nil
      end
    end

    def previous_route_id(user_id)
      if user_checkpoints(user_id).start_points.previous
        user_checkpoints(user_id).start_points.previous.route_id
      end
    end

    def is_valid?(checkpoint_data)
      if checkpoint_data["type"] == "heartbeat"
        return current_route(checkpoint_data["user_id"])
        puts "Checkpoint:is_valid?:Invalid Checkpoint: trailing heartbeats"
      elsif checkpoint_data["type"] == "prayer"
        return checkpoint_data["match_key"] != ""
        puts "Checkpoint:is_valid?:Invalid Checkpoint: no resident match key given"
      else
        true
      end
    end

    def new_checkpoint(data)
      if is_valid?(data)
        if data["lat"] == 0 || data["long"] == 0
          if current_route = Checkpoint.current_route(data["user_id"])
            puts "Checkpoint:new_checkpoint:user_id: #{data["user_id"]}:current_route: #{current_route.id}"         
            prev_checkpoint = last_route_checkpoint(data["user_id"], current_route.id)
            puts "Checkpoint:new_checkpoint:prev_checkpoint: #{prev_checkpoint}"
            data["lat"]     = prev_checkpoint.lat
            data["long"]    = prev_checkpoint.long
          end
        end

        data["recorded_at"] = Time.now.to_i
        puts "TIME!!!: #{Time.now.to_i}"
        checkpoint = new(data)
        checkpoint.save
        checkpoint
      else
        puts "Checkpoint:new_checkpoint:We refused to put an invalid checkpoint into the database"
        nil
      end
    end

    def last_prayer(user_id)
      checkpoint = last_user_checkpoint(user_id, "prayer")
      checkpoint.match_key if checkpoint
    end

    def last_user_checkpoint(user_id, type)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S > :s",
        filter_expression: "contains(#T, :t)",
        expression_attribute_names: {
          "#U" => "user_id",
          "#T" => "type",
          "#S" => "recorded_at"
        },
        expression_attribute_values: {
          ":u" => user_id,
          ":t" => type,
          ":s" => 0
        }
      )
      puts "Checkpoint:last_user_checkpoint:user_id #{user_id}"
      puts "Checkpoint:last_user_checkpoint:type #{type}"
      query.to_a.last
    end

    def last_checkpoint(user_id)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S > :s",
        expression_attribute_names: {
          "#U" => "user_id",
          "#S" => "recorded_at"
        },
        expression_attribute_values: {
          ":u" => user_id,
          ":s" => 0
        }
      )
      query.to_a.last
    end

    def last_route_checkpoint(user_id, route_id)
      query = Checkpoint.query(
        key_condition_expression: "user_id = :u AND recorded_at > :s",
        filter_expression: "route_id = :r",
        expression_attribute_values: {
          ":u" => user_id,
          ":r" => route_id,
          ":s" => 0
        }
      )
      query.to_a.last
    end

    def route_checkpoints(user_id, route_id)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S > :s",
        filter_expression: "#R = :r",
        expression_attribute_names: {
          "#U" => "user_id",
          "#R" => "route_id",
          "#S" => "recorded_at"
        },
        expression_attribute_values: {
          ":u" => user_id,
          ":r" => route_id,
          ":s" => 0
        }
      )
    end

    def previous_checkpoint(checkpoint)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S < :s",
        filter_expression: "#R = :r",
        expression_attribute_names: {
          "#U" => "user_id",
          "#R" => "route_id",
          "#S" => "recorded_at"
        },
        expression_attribute_values: {
          ":u" => checkpoint.user_id,
          ":r" => checkpoint.route_id,
          ":s" => checkpoint.recorded_at
        }
      )
    end

    def user_checkpoints(user_id)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #R > :r",
        # filter_expression: "#R = :r",
        expression_attribute_names: {
          "#U" => "user_id",
          "#R" => "recorded_at"
        },
        expression_attribute_values: {
          ":u" => user_id,
          ":r" => 0
        }
      )
    end
  end #END OF CLASS METHODS

  def distance(checkpoint = nil)
    previous_checkpoint = checkpoint || Checkpoint.previous_checkpoint(self).to_a.last
    if (previous_checkpoint && lat != "0" && long != "0" && previous_checkpoint.lat != "0" && previous_checkpoint.long != "0")
      delta_x = ((self.long.to_f - previous_checkpoint.long.to_f) * 55)
      delta_y = ((self.lat.to_f - previous_checkpoint.lat.to_f) * 69)
      Math.sqrt((delta_x * delta_x) + (delta_y * delta_y))
    else
      0
    end
  end

  def set_route_id 
    if type == "start"
      route = Route.new_route(user_id)
    else 
      route = Checkpoint.current_route(user_id)
      if route && type == "prayer"
        route.prayer_count += 1
        route.save!
      end
    end
    self.route_id = route.id if route
  end

  def save!
    save
  end

  def save
    self.route_id = set_route_id unless persisted?
    super
    Route.finalize(user_id, route_id) if type == "stop"
  end
end