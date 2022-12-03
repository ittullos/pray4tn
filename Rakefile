require "bundler"
Bundler.require
require "dotenv"

Dotenv.load

if ENV["RACK_ENV"] == "dev"
  DB = Sequel.connect(ENV["DB_DEV"])
elsif ENV["RACK_ENV"] == "prod"
  DB = Sequel.connect(:adapter => 'mysql2', 
                      :host => (ENV["DB_HOST"]),
                      :port => 3306, :user => 'admin', 
                      :password => (ENV["DB_PWRD"]), 
                      :database => (ENV["DB_NAME"]))
else
  DB = Sequel.connect(ENV["DB_TEST"])
end

require "./app/models/verse"
require "./app/models/user"

namespace :db do
  desc "Run Migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel::Migrator.run(DB, 'db/migrations', target: version)
  end
  desc "Seed Database"
  task :seed do
    Verse.insert(
      scripture: "Love is patient and kind; love does not envy or boast; it is not arrogant or rude. It does not insist on its own way; it is not irritable or resentful.",
      version: "ESV",
      notation: "1 Corinthians 13:4-5")
    Verse.insert(
      scripture: "Rejoice always, pray without ceasing, give thanks in all circumstances; for this is the will of God in Christ Jesus for you.",
      version: "ESV",
      notation: "1 Thessalonians 5:16-18")
    Verse.insert(
      scripture: "Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.",
      version: "ESV",
      notation: "Philippians 4:6-7")
    User.insert(
      email: "user@example.com",
      password: "password"
    )
  end
end