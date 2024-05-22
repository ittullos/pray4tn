
FactoryBot.define do
  factory :prayer do
    user
    route
    resident
    recorded_at { DateTime.current }
  end
end
