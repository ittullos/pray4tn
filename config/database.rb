# frozen_string_literal: true
require 'sinatra'
require 'sinatra/sequel'

set :database, ENV['DATABASE_URL']
