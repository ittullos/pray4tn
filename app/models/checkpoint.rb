require_relative 'route'

class Checkpoint
  include Aws::Record
  set_table_name ENV["CHECKPOINT_TABLE_NAME"]

  integer_attr :user_id,   hash_key: true
  integer_attr :timestamp, range_key: true
  integer_attr :route_id
  string_attr  :lat
  string_attr  :long
  string_attr  :type
  string_attr  :match_key
  
  class << self
    def end_route(checkpoint)
      User[checkpoint.user_id].add_checkpoint(timestamp: Time.now.to_i,
                                              lat:       checkpoint.lat,
                                              long:      checkpoint.long,
                                              type:      "stop")
    end

    def close_last_route(user_id)
      checkpoint = last_checkpoint(user_id)
      if checkpoint && checkpoint.type != "stop"
        end_route(checkpoint)
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
      if last_start_checkpoint
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
      true unless checkpoint_data["type"] == "heartbeat" && !current_route(checkpoint_data["userId"])
    end

    def new_checkpoint(data)
      if is_valid?(data)
        # Need to remember to skip start points
        if data["lat"] == 0 || data["long"] == 0
          if current_route = Checkpoint.current_route(user_id)
            prev_checkpoint = last_route_checkpoint(user_id, current_route.id)
            data["lat"]     = prev_checkpoint.lat
            data["long"]    = prev_checkpoint.long
          end
        end

        data["user_id"] = data["userId"]
        data.delete("userId")
        data["timestamp"] = Time.now.to_i
        puts "TIME!!!: #{Time.now.to_i}"
        checkpoint = new(data)
        checkpoint.save
        checkpoint
      else
        nil
      end
    end

    def last_name(user_id)
      puts "checkpoint#last_name not implemented yet"
    end

    def add_checkpoint(user_id, data)
      data[:user_id] = user_id
      new_checkpoint = new(data)
      new_checkpoint.save
      new_checkpoint
    end

    def last_user_checkpoint(user_id, type)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S > :s",
        filter_expression: "contains(#T, :t)",
        expression_attribute_names: {
          "#U" => "user_id",
          "#T" => "type",
          "#S" => "timestamp"
        },
        expression_attribute_values: {
          ":u" => user_id,
          ":t" => type,
          ":s" => 0
        }
      )
      query.to_a.last
    end

    def last_checkpoint(user_id)
      query = Checkpoint.query(
        key_condition_expression: "#U = :u AND #S > :s",
        expression_attribute_names: {
          "#U" => "user_id",
          "#S" => "timestamp"
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
        key_condition_expression: "#U = :u AND #S > :s",
        filter_expression: "contains(#R, :r)",
        expression_attribute_names: {
          "#U" => "user_id",
          "#R" => "route_id",
          "#S" => "timestamp"
        },
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
          "#S" => "timestamp"
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
          "#S" => "timestamp"
        },
        expression_attribute_values: {
          ":u" => checkpoint.user_id,
          ":r" => checkpoint.route_id,
          ":s" => checkpoint.timestamp
        }
      )
    end
  end #END OF CLASS METHODS

  def distance(checkpoint = nil)
    previous_checkpoint = checkpoint || Checkpoint.previous_checkpoint(self).to_a.last
    if (lat != "0" && long != "0" && previous_checkpoint.lat != "0" && previous_checkpoint.long != "0")
      delta_x = ((self.long.to_f - previous_checkpoint.long.to_f) * 55)
      delta_y = ((self.lat.to_f - previous_checkpoint.lat.to_f) * 69)
      Math.sqrt((delta_x * delta_x) + (delta_y * delta_y))
    else
      0
    end
  end

  def set_route_id 
    if type == "start"
      route = Route.new_route
    else 
      route = Checkpoint.current_route(user_id)
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