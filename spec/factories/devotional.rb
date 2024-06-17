# frozen_string_literal: true

FactoryBot.define do
  factory :devotional do
    sequence :title do |n|
      "Daily Bread #{n}"
    end
    url { 'https://dailybread.com' }
    img_url { 'https://dailybread.com/img.jpg' }
  end
end
