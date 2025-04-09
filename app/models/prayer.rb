# frozen_string_literal: true

class Prayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :resident
  belongs_to :route, optional: true

  validates :recorded_at, presence: true
  validates :resident, presence: true
end
