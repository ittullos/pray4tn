# frozen_string_literal: true

FactoryBot.define do
  factory :resident_list do
    user
    loaded_at { DateTime.current }

    trait :with_residents do
      after(:create) do |resident_list, context|
        create_list(:resident, 3, resident_list: resident_list)
        resident_list.reload
      end
    end
  end
end
