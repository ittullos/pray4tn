require 'sequel'

ENV['RACK_ENV'] ||= "development"
require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

require 'rubygems'
require 'sinatra'
require 'pry-byebug'
require './app/pray4tn'