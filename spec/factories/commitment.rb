# frozen_string_literal: true

FactoryBot.define do
  factory :commitment do
    user
    journey
    start_date { Date.current }
    end_date { Date.current + 1.year }
  end
end
