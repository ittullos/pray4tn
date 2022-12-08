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

    def next_to_last
      order_by(Sequel.desc(:id)).limit(2).offset(1).first
    end

    def most_recent
      order_by(Sequel.desc(:id)).first
    end
  end

  def calculate_distance()
    delta_x = ((long.to_f - Checkpoint.user_checkpoints(user.id).next_to_last.long.to_f) * 55)
    delta_y = ((lat.to_f - Checkpoint.user_checkpoints(user.id).next_to_last.lat.to_f)  * 69)
    return (Math.sqrt((delta_x * delta_x) + (delta_y * delta_y)))
  end

  def before_create
    if type == "start"
      if  Checkpoint.user_checkpoints(user.id).start_points.count > 1
        if Checkpoint.user_checkpoints(user.id).most_recent.type != "stop"
          checkpoint = user.add_checkpoint(timestamp: Time.now.to_i,
                                           lat:       0,
                                           long:      0,
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
      self.route.calculate_route_data
    end
    super
  end
end