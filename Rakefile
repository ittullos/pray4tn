require "bundler"
Bundler.require
require "dotenv"

Dotenv.load

if ENV["RACK_ENV"] == "prod"
  DB = Sequel.connect(:adapter => 'mysql2', :host => 'test-pr.cnklfpyep1np.us-east-1.rds.amazonaws.com',:port => 3307, :user => 'admin', :password => 'FullStack710', :database => 'test-prod') 
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