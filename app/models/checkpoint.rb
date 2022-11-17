class Checkpoint < Sequel::Model
  many_to_one :user
  many_to_one :route

  def after_create 
    if self.type == "start"
      route  = Route.insert(started_at:   Time.now.to_i,
                            mileage:      0,
                            prayer_count: 0,
                            seconds:      0)
      self.route_id = route
      self.save
    elsif self.type == "heartbeat"
      user_id = self.user_id
      self.route_id = User[user_id].last_route_id
      self.save
    end
    super
  end
end