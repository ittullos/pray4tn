class Route < Sequel::Model
  one_to_many :checkpoints
  Precision = 1000

  def km_to_mi (km)
    mi = km * 0.6214
    return mi
  end

  def finalize
    self.seconds = (self.checkpoints.last.timestamp - self.checkpoints.first.timestamp)
    self.stopped_at = Time.now.to_i
    mileage_count = 0.0

    if self.checkpoints.count > 1
      for i in 1..((self.checkpoints.count) - 1) do
        mileage_count += self.checkpoints[i].distance
      end
      self.mileage = (mileage_count * Precision).round(0)
    end
    self.save
  end
end