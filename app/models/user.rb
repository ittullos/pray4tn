class User < Sequel::Model
  one_to_many :commitments
  one_to_many :checkpoints

  def route_ids
    self.checkpoints.map { |point| point.route_id }.uniq.compact
  end

  def last_route_id
    self.route_ids.sort.last
  end

  def prev_route_id
    if self.route_ids.count > 1    
      return_id = self.route_ids[-2]
    else
      return_id = self.last_route_id
    end
    return_id
  end
end