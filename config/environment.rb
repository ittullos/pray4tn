# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('app', __dir__))

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load

require_relative '../app/app'
