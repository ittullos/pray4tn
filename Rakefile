# frozen_string_literal: true

# Load all .rake files from lib/tasks
# Dir.glob('lib/tasks/*.rake').each { |r| load r }
require 'sinatra/activerecord/rake'

# This is the change I made when changing to a .rb file instead of .rake
require './lib/tasks/db_seed_users'


namespace :db do
  desc 'loads application'
  task :load_config do
    require './app/app'
  end

  namespace :seed do
    desc "Seed users from /db/seeds/users.yml"
    task :users => :environment do
      SeedUsers.run
    end
  end
end
