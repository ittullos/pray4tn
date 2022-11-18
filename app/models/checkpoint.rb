class Checkpoint < Sequel::Model
  many_to_one :user
  many_to_one :route

  # def self.route_ids(user_id)
  #   # pry.byebug
  #   Checkpoint.where(user_id: user_id)
  # end

  # def self.last_route_id
  #   # pry.byebug
  # end

  # def self.prev_route_id(user_id)
  #   pry.byebug
  # end

  def after_create 
    if self.type == "start"
      route  = Route.insert(started_at:   Time.now.to_i,
                            mileage:      0,
                            prayer_count: 0,
                            seconds:      0)
      self.route_id = route
      self.save

      if self.user.prev_route_id != self.user.last_route_id
        
        if Route[self.user.prev_route_id].checkpoints.last.type != "stop"
          checkpoint = self.user.add_checkpoint(timestamp: Time.now.to_i,
                                                lat:       0,
                                                long:      0,
                                                type:      "stop")      
          checkpoint.route_id = Route[self.user.prev_route_id].id
          checkpoint.save  
        end
      end

    elsif self.type == "heartbeat" || self.type == "stop"
      user_id = self.user_id
      self.route_id = User[user_id].last_route_id
      self.save   
    end

    if self.type == "stop" 
      self.route.calculate_route_data
    end
    super
  end
end