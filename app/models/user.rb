class User < Sequel::Model
  one_to_many :commitments
  one_to_many :checkpoints

  def route_ids
    self.checkpoints.map { |point| point.route_id }.uniq.compact
  end

  def last_route_id
    self.route_ids.sort.last
  end
end