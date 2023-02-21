require "bundler"
Bundler.require
require "dotenv"
require "./spec/dinodb"

Dotenv.load

require './app/models/verse'
require './app/models/user'
require './app/models/checkpoint'
require './app/models/route'
require './app/models/user_resident'

models = [ Verse, 
           Route, 
           Checkpoint,
           User,
           UserResident ]

names       = ["John Stewart", "Stephen Colbert", "Trever Noah"]
addresses   = ["44 Unknown dr", "431 Canberra dr", "607 Middlebrook pk"]

namespace :db do
  desc "Run Migrations"
  task :migrate do 
    models.each do |model|
      migrate_model(model)
    end
  end
  desc "Drop Tables"
  task :drop do 
    models.each do |model|
      delete_table(model)
    end
  end
  desc "Seed Database"
  task :seed do
    Verse.new_verse(
      scripture: "Love is patient and kind; love does not envy or boast; it is not arrogant or rude. It does not insist on its own way; it is not irritable or resentful.",
      version:   "ESV",
      notation:  "1 Corinthians 13:4-5")
    Verse.new_verse(
      scripture: "Rejoice always, pray without ceasing, give thanks in all circumstances; for this is the will of God in Christ Jesus for you.",
      version:   "ESV",
      notation:  "1 Thessalonians 5:16-18")
    Verse.new_verse(
      scripture: "Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.",
      version:   "ESV",
      notation:  "Philippians 4:6-7")
    user_id = User.new_user(email: "user@example.com", password: "1")

    # for i in 0..2 do
    #   user.add_user_resident(
    #     name: names[i],
    #     address: addresses[i],
    #     status: "active"
    #   )
    end
    
  end
end