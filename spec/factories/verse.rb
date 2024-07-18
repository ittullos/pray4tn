FactoryBot.define do
  factory :verse do
    sequence(:day) { |n| n }
    scripture { "scripture #{day}" }
    notation { 'John 3:16' }
    version { 'NIV' }
  end
end
