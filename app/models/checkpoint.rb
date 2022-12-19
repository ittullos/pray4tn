class Checkpoint < Sequel::Model
  many_to_one :user
  many_to_one :route

  dataset_module do
    def user_checkpoints(user_id)
      where(:user_id => user_id)
    end

    def start_points
      where(:type => "start")
    end

    def most_recent
      order_by(Sequel.desc(:id)).first
    end

    def previous_route_checkpoint(checkpoint)
      where(:route_id => checkpoint.route_id).where{id < checkpoint.id}.order_by(Sequel.desc(:id)).first
    end
  end

  def distance
    previous_checkpoint = Checkpoint.user_checkpoints(user_id).previous_route_checkpoint(self)
    if (lat != "0" && long != "0" && previous_checkpoint.long != "0" && previous_checkpoint.long != "0")
      delta_x = ((long.to_f - previous_checkpoint.long.to_f) * 55)
      delta_y = ((lat.to_f - previous_checkpoint.lat.to_f) * 69)
      Math.sqrt((delta_x * delta_x) + (delta_y * delta_y))
    else
      0
    end
  end

  def before_create
    if type == "start"
      if  Checkpoint.user_checkpoints(user.id).start_points.count > 1
        if Checkpoint.user_checkpoints(user.id).most_recent.type != "stop"
          checkpoint = user.add_checkpoint(timestamp: Time.now.to_i,
                                           lat:       Checkpoint.user_checkpoints(user.id).most_recent.lat,
                                           long:      Checkpoint.user_checkpoints(user.id).most_recent.long,
                                           type:      "stop")                                        
          checkpoint.route_id = Checkpoint.user_checkpoints(user.id).most_recent.route_id
          checkpoint.save  
        end
      end
    end
  end

  def after_create 
    if type == "start"
      route  = Route.insert(started_at:   Time.now.to_i,
                            mileage:      0,
                            prayer_count: 0,
                            seconds:      0)
      self.route_id = route
      self.save
    elsif type == "heartbeat" || self.type == "stop"
      self.route_id = Checkpoint.user_checkpoints(user.id).start_points.most_recent.route_id
      self.save   
    end
    if type == "stop" 
      self.route.finalize
    end
    super
  end
end