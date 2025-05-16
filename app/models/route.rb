# frozen_string_literal: true

class Route < ActiveRecord::Base
  belongs_to :user
  belongs_to :commitment, optional: true
  has_many :prayers

  validates :mileage, numericality: true
  validates :seconds, numericality: true

  def stop
    self.stopped_at = Time.current
  end

  def calculate_route_time
    raise StandardError, 'Route has not been started!' unless started_at

    end_time = stopped_at || Time.current
    self.seconds = (end_time - started_at).to_i
  end
end
