# frozen_string_literal: true

require 'sinatra/activerecord/rake'

# Load all files in the lib directory
Dir.glob('lib/*.rb').each { |file| require_relative file }

namespace :db do
  desc 'loads application'
  task :load_config do
    require './app/app'
  end

  namespace :seed do
    desc "Seed users from /db/seeds/users.yml"
    task :users => :load_config do
      SeedUsers.run
    end
    desc "Seed verses from /db/seeds/verses.yml"
    task :verses => :load_config do
      SeedVerses.run
    end
  end
end
