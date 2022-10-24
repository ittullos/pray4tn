# require 'sequel'
# require 'mysql2'
# Sequel.connect(:adapter => 'mysql2', :host => (ENV["DB_HOST"]),:port => 3306, :user => 'admin', :password => (ENV["DB_PWRD"]), :database => 'test')



class Verse < Sequel::Model
end