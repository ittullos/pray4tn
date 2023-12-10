# frozen_string_literal: true

FactoryBot.define do
  factory :route do
    user
    commitment
    started_at { DateTime.current }
    stopped_at { DateTime.current + 1.year }
    step_count { 120 }
    seconds { 10 }
  end
end
