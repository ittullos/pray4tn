require 'json'
require 'sinatra'
require 'mysql2'


puts ENV["DB_HOST"]

Sequel.connect(:adapter => 'mysql2', :host => (ENV["DB_HOST"]),:port => 3306, :user => 'admin', :password => (ENV["DB_PWRD"]), :database => 'test')

require './app/models/verse'

get '/hello' do
  # content_type :json
  # { 
  #   verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
  #   notation: "John 3:16 ESV" 
  # }.to_json
  @verse = Verse.first
  content_type :json
  { 
    verse: @verse.scripture,
    notation: @verse.notation,
    version: @verse.version
  }.to_json
end




