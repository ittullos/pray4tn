# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Isaac' }
    last_name { 'Tullos' }
    sequence :email do |n|
      "#{first_name}.#{last_name}#{n}@example.com".downcase
    end
    sequence :sub do |n|
      "cognito|#{n}"
    end
  end
end
