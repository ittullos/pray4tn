require 'aws-record'

class RouteNoIdError < StandardError; end
class Route
  include Aws::Record
  set_table_name ENV["ROUTE_TABLE_NAME"]

  integer_attr  :id,            hash_key: true
  integer_attr  :started_at
  integer_attr  :stopped_at
  integer_attr  :mileage
  integer_attr  :prayer_count
  integer_attr  :seconds
  integer_attr  :commitment_id

  PRECISION = 1000

  def self.new_route(user_id)
    route = new(started_at: Time.now.to_i, prayer_count: 0, commitment_id: User.find(email: user_id).commitment_id)
    route.save!
    route
  end

  def self.new_test_route(seconds, prayers, distance)
    route = new(seconds: seconds, prayer_count: prayers, commitment_id: 1, mileage: distance)
    route.save!
    route
  end

  def self.next_route_id
    last_route_id = self.scan.inject(0) { |m, r| r.id > m ? r.id : m }
    return last_route_id + 1
  end

  def self.query
    q = Route.build_query.key_expr(
        ":id > ?", 0
      ).scan_ascending(false).complete!
    q.to_a # You can use this like any other query result in aws-record
  end

  def save!
    save
  end

  def save
    unless persisted?
      self.id = Route.next_route_id
    end
    if self.id.nil? 
      raise RouteNoIdError, "Tried to save route with no ID"
    end   
    super
  end

  def self.finalize(user_id, route_id)
    # pry.byebug
    route = find(id: route_id)
    route.finalize(user_id)
    user = User.find(email: user_id)
    if user.commitment_id != 0
      mileage_total = 0
      Route.scan.each do |route|
        # pry.byebug
        if route.commitment_id == user.commitment_id
          mileage_total += route.mileage
        end
      end
      if user.achievement < mileage_total
        user.achievement = mileage_total
        user.save
      end
    end
  end

  def finalize(user_id)
    checkpoints = Checkpoint.route_checkpoints(user_id, id).to_a
    self.seconds = (checkpoints.last.recorded_at - checkpoints.first.recorded_at)
    self.stopped_at = Time.now.to_i
    mileage_count = 0.0
    if checkpoints.count > 1
      for i in 1..((checkpoints.count) - 1) do
        if checkpoints[i].type == "heartbeat" || checkpoints[i].type == "stop"
          mileage_count += checkpoints[i].distance(checkpoints[i-1])
        end
      end
      self.mileage = (mileage_count * PRECISION).round(0)
    end
    save
  end

  def is_closed?
    !stopped_at.nil?
  end
end