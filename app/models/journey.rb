# frozen_string_literal: true

class Journey < ActiveRecord::Base
  validates :annual_miles, presence: true, numericality: true
  validates :monthly_miles, presence: true, numericality: true
  validates :weekly_miles, presence: true, numericality: true
  validates :title, presence: true, uniqueness: true

  MILEAGE_CONVERSION_FACTOR = 0.01
end
