require 'sequel'
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


RSpec.configure do |c|
  c.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
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

  