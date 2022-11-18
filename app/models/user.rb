class User < Sequel::Model
  one_to_many :commitments
  one_to_many :checkpoints

  def route_ids
    checkpoints.map { |point| point.route_id }.uniq.compact
  end

  def last_route_id
    route_ids.sort.last
    # Checkpoint.last_route_id(id)
  end

  def prev_route_id
    if route_ids.count > 1    
      return_id = route_ids[-2]
    else
      return_id = last_route_id
    end
    return_id
  end
end