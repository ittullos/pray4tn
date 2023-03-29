require 'logger'
ENV['RACK_ENV'] = "test"
require 'aws-record'
require_relative 'dinodb'

require './config/environment'
require 'rack/test'
require './app/app'
require './app/models/verse'
require './app/models/user'
require './app/models/checkpoint'
require './app/models/route'
require './app/models/user_resident'
require './app/models/devotional'
require './app/models/journey'
require './app/models/commitment'

def km_to_mi (km)
  mi = km * 0.6214
  return mi
end

def random_location
  RandomLocation.near_by(36.174465, -86.767960, 1000)
end

def distance(location, prev_location)
  delta_x = ((location["long"].to_f - prev_location["long"].to_f) * 55)
  delta_y = ((location["lat"].to_f - prev_location["lat"].to_f) * 69)
  Math.sqrt((delta_x * delta_x) + (delta_y * delta_y))
end

VERSES = [
  { 
    "scripture" => "Love is patient and kind; love does not envy or boast; it is not arrogant or rude. It does not insist on its own way; it is not irritable or resentful.",
    "version" => "ESV",
    "notation" => "1 Corinthians 13:4-5" 
  },
  {
    "scripture" => "Rejoice always, pray without ceasing, give thanks in all circumstances; for this is the will of God in Christ Jesus for you.",
    "version" => "ESV",
    "notation" => "1 Thessalonians 5:16-18"
  },
  {
    "scripture" => "Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.",
    "version" => "ESV",
    "notation" => "Philippians 4:6-7"
  }
]
