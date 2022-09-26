# require_relative 'models/user'
# require_relative 'models/commitment'
require 'json'
require 'sinatra'

# class Pray4TN < Sinatra::Base

  get '/hello' do
    "Hello World!"
    content_type :json
    { 
      verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
      notation: "John 3:16 ESV" 
    }.to_json
  end

  get '/hello/' do
    "Hello World!"
  end

  get '/votd' do
    content_type :json
    { 
      verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
      notation: "John 3:16 ESV" 
    }.to_json
  end

# end


