require 'sequel'
require 'dotenv'

Dotenv.load

ENV['RACK_ENV'] ||= "dev"
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

DB = Sequel.connect(ENV["DB_DEV"])

require 'rubygems'
require 'sinatra'
require 'pry-byebug'
require './app/app'