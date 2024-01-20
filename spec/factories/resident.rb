# frozen_string_literal: true

FactoryBot.define do
  factory :resident do
    loaded_at { Date.current }
    sequence :name do |n|
      "Resident#{n}"
    end
  end
end
