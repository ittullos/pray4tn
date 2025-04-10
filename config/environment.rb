# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('app', __dir__))

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

# Only load Dotenv in development or test environments
if %w[development test].include?(ENV['RACK_ENV'])
  require 'dotenv'
  Dotenv.load
end

require_relative '../app/app'
