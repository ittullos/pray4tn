# frozen_string_literal: true

FactoryBot.define do
  factory :journey do
    annual_miles { 36_500 }
    monthly_miles { 3_000 }
    weekly_miles { 700 }
    sequence :title do |n|
      "My Journey #{n}"
    end
  end
end
