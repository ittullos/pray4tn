# frozen_string_literal: true

class User < ActiveRecord::Base
  validates_presence_of :email, :sub
  validates_uniqueness_of :email
  validates_uniqueness_of :sub

  has_many :residents, -> { order(position: :asc) }
  has_many :routes
  has_many :commitments, -> { order(created_at: :desc) }
  has_many :prayers

  def current_commitment
    commitments.first
  end

  def stats
    total_distance = routes.sum(:mileage)
    total_prayers = prayers.count
    total_duration = routes.sum(:seconds)

    current_commitment = self.current_commitment
    current_journey = current_commitment&.journey
    if current_commitment
      commitment_distance = routes.where(commitment_id: current_commitment.id).sum(:mileage)
      commitment_duration = routes.where(commitment_id: current_commitment.id).sum(:seconds)
      commitment_prayers = current_commitment.prayers.count
      commitment_end_date = current_commitment.end_date
    else
      commitment_distance = 0
      commitment_duration = 0
      commitment_prayers = 0
      commitment_end_date = nil
    end

    {
      total_distance: total_distance,
      total_prayers: total_prayers,
      total_duration: total_duration,
      commitment_distance: commitment_distance,
      commitment_duration: commitment_duration,
      commitment_prayers: commitment_prayers,
      current_journey: current_journey,
      commitment_end_date: commitment_end_date
    }
  end
end
