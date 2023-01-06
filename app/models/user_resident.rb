class UserResident < Sequel::Model
  many_to_one :user

  dataset_module do
    def active
      where(:status => "active")
    end

    def next_up
      order_by(Sequel.desc(:id)).first
    end


    # def user_checkpoints(user_id)
    #   where(:user_id => user_id)
    # end

    # def start_points
    #   where(:type => "start")
    # end

    # def most_recent
    #   order_by(Sequel.desc(:id)).first
    # end

    # def previous_route_checkpoint(checkpoint)
    #   where(:route_id => checkpoint.route_id).where{id < checkpoint.id}.order_by(Sequel.desc(:id)).first
    # end
  end
end