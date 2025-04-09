# frozen_string_literal: true

FactoryBot.define do
  factory :route do
    user
    commitment
    started_at { DateTime.current }
    stopped_at { nil }
    mileage { 120 }
    seconds { 10 }
  end
end
