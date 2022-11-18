class Route < Sequel::Model
  one_to_many :checkpoints

  def km_to_mi (km)
    mi = km * 0.6214
    return mi
  end

  def calculate_route_data
    self.seconds = (self.checkpoints.last.timestamp - self.checkpoints.first.timestamp)

    if self.checkpoints.count > 2
      mileage_count = 0.0

      for i in 1..((self.checkpoints.count) -1) do      
        distance = Haversine.distance(self.checkpoints[i-1].lat.to_f,
                                      self.checkpoints[i-1].long.to_f,
                                      self.checkpoints[i].lat.to_f,
                                      self.checkpoints[i].long.to_f)
      
        mileage_count += km_to_mi(distance.to_km)
      end
      self.mileage = (mileage_count * 10).to_i    
    end
    self.save
  end
end