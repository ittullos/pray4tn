# frozen_string_literal: true

FactoryBot.define do
  factory :resident do
    resident_list
    loaded_at { Date.current }
    sequence :name do |n|
      "Resident#{n}"
    end
    sequence(:position) { |n| n }
  end
end
