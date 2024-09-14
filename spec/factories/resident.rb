# frozen_string_literal: true

FactoryBot.define do
  factory :resident do
    user
    loaded_at { Time.current }
    sequence :name do |n|
      "Resident#{n}"
    end
    sequence(:position) { |n| n }
  end
end
