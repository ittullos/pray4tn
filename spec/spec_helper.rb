require 'sequel'
require 'logger'
ENV['RACK_ENV'] = "test"

require './config/environment'
DB = Sequel.connect(ENV["DB_TEST"])
require 'rack/test'
require 'rspec/sequel'
require './app/app'
require './app/models/verse'
require './app/models/user'
require './app/models/checkpoint'
require './app/models/route'

class Checkpoint
  dataset_module do
    def next_to_last
      order_by(Sequel.desc(:id)).limit(2).offset(1).first
    end
  end
end

RSpec.configure do |c|
  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
end

DB.loggers << Logger.new($stdout)

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

TEST_ROUTE = [
  {
    "timestamp" => 1668660018,
    "lat"       => 36.175080062003715,
    "long"      => -86.8311598921416,
    "type"      => "start"
  },
  {
    "timestamp" => 1668660078,
    "lat"       => 36.16632472398893,
    "long"      => -86.75612360308308,
    "type"      => "heartbeat"
  },
  {
    "timestamp" => 1668660138,
    "lat"       => 36.16612439458566,
    "long"      => -86.8523964024885,
    "type"      => "heartbeat"
  },
  {
    "timestamp" => 1668660198,
    "lat"       => 36.17035610315898,
    "long"      => -86.83360081319711,
    "type"      => "heartbeat"
  },
  {
    "timestamp" => 1668660318,
    "lat"       => 36.17769072161397,
    "long"      => -86.86458524697652,
    "type"      => "stop"
  }
]

TEST_DISTANCE = 0
TEST_DURATION = 0

for i in 0..3 do
  @distance = distance(TEST_ROUTE[i + 1], TEST_ROUTE[i])

  TEST_DISTANCE += @distance
  TEST_DURATION += (TEST_ROUTE[i + 1]["timestamp"] - TEST_ROUTE[i]["timestamp"])
end 
TEST_DISTANCE = (TEST_DISTANCE * 1000).round(0)