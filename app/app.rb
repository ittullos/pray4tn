# require_relative 'models/user'
# require_relative 'models/commitment'
require 'json'
require 'sinatra'
# require 'sinatra/cross_origin'
# require "sinatra/cors"



get '/hello' do
  # "Hello World!"
  content_type :json
  { 
    verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
    notation: "John 3:16 ESV" 
  }.to_json
end

# get '/hello/' do
#   # "Hello World!"
# end

get '/votd' do
  content_type :json
  { 
    verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
    notation: "John 3:16 ESV" 
  }.to_json
end



