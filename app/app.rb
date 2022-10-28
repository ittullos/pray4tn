require 'json'
require 'sinatra'
require 'mysql2'
require 'sequel'

before do
  Sequel.connect(:adapter => 'mysql2',
    :host => (ENV["DB_HOST"]),
    :port => 3306,
    :user => 'admin',
    :password => (ENV["DB_PWRD"]),
    :database => 'test')
  require './models/verse'
end

get '/hello' do
  @verse = Verse.first
  content_type :json
  { 
    verse: @verse.scripture,
    notation: @verse.notation,
    version: @verse.version
  }.to_json
end