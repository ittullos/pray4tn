require 'sequel'

ENV['RACK_ENV'] ||= "development"
DB_FILE = "db/pray4tn_#{ENV['RACK_ENV']}.db"
puts "database file name: #{DB_FILE}"
Sequel::Model.db = Sequel.mysql2 DB_FILE

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require 'rubygems'
require 'sinatra'
require 'pry-byebug'
require './app/pray4tn'