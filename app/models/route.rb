# frozen_string_literal: true

class Route < ActiveRecord::Base
  belongs_to :user
  belongs_to :commitment, optional: true
  has_many :prayers

  validates :mileage, numericality: true
  validates :seconds, numericality: true
end
