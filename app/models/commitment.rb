# frozen_string_literal: true

class Commitment < ActiveRecord::Base
  belongs_to :user

  validates :end_date, comparison: { greater_than: :start_date }

  attribute :start_date, default: -> { Date.current }
  attribute :end_date, default: -> { Date.current + 1.year }
end
