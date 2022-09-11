require "bundler"
Bundler.require
require "dotenv"

Dotenv.load

namespace :db do
  desc "Run Migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    DB = Sequel.connect(ENV["DB_DEV"]) 
    Sequel::Migrator.run(DB, 'db/migrations', target: version)
  end
end