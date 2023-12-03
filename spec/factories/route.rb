# frozen_string_literal: true

FactoryBot.define do
  factory :route do
    user
    commitment
    # start_date { Date.current }
    # end_date { Date.current + 1.year }

  end
end
