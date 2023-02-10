require 'dotenv'

Dotenv.load

ENV['RACK_ENV'] ||= "dev"
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require 'rubygems'
require 'sinatra'
require 'pry-byebug'
require 'random_name_generator'
require './app/app'