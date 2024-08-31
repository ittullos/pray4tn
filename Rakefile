# frozen_string_literal: true

require './app/app'
require 'sinatra/activerecord/rake'

# Load all files in the lib directory
Dir.glob('lib/*.rb').each { |file| require_relative file }

namespace :db do
  namespace :seed do
    desc "Seed users from /db/seeds/users.yml"
    task :users => :environment do
      SeedUsers.run
    end
    desc "Seed verses from /db/seeds/verses.yml"
    task :verses => :environment do
      SeedVerses.run
    end
  end
end
