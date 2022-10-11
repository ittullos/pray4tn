require "bundler"
Bundler.require
require "dotenv"

Dotenv.load

if ENV["RACK_ENV"] == "prod"
  DB = Sequel.connect(:adapter => 'mysql2', :host => (ENV["DB_HOST"]),:port => 3306, :user => 'admin', :password => (ENV["DB_PWRD"]), :database => 'test') 
else
  DB = Sequel.connect(ENV["DB_DEV"])
end 

# pry

namespace :db do
  desc "Run Migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel::Migrator.run(DB, 'db/migrations', target: version)
  end
end