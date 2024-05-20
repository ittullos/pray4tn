FactoryBot.define do
  factory :verse do
    sequence(:day) { |n| n }
    scripture { 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.' }
    notation { 'John 3:16' }
    version { 'NIV' }
  end
end
