require './config/environment'

namespace :db do
  desc "Run Migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:vesion]
    puts "migrating: #{DB_FILE}"
    Sequel.mysql2(DB_FILE) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end
  desc "Seed Database"
  task :seed do
    # AccountType.insert(type: "savings")
    # AccountType.insert(type: "checking")
    # AccountType.insert(type: "investment")
  end
end