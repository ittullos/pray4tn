class Checkpoint < Sequel::Model
  many_to_one :user
  many_to_one :route

  def self.get_user_checkpoints(user_id)
    Checkpoint.where(user_id: user_id).order_by(Sequel.desc(:id))
  end

  def self.user_checkpoints(user_id)
    get_user_checkpoints(user_id).all
  end

  def self.user_route_ids(user_id)
    user_checkpoints(user_id).map { |point| point.route_id }.uniq.compact
  end

  def self.last_route(user_id)
    get_user_checkpoints(user_id).first.route
  end

  def self.last_checkpoint(user_id)
    get_user_checkpoints(user_id).first
  end



  def before_create
    if type == "start"
      if  Checkpoint.user_route_ids(user.id).count > 1
        if Checkpoint.last_checkpoint(user.id).type != "stop"
          checkpoint = user.add_checkpoint(timestamp: Time.now.to_i,
                                                lat:       0,
                                                long:      0,
                                                type:      "stop") 
                                                
          checkpoint.route_id = Checkpoint.last_route(user.id).id
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
      self.route_id = Checkpoint.user_route_ids(user.id).sort.last
      self.save   
    end

    if type == "stop" 
      self.route.calculate_route_data
    end
    super
  end
end