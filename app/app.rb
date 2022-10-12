require 'json'
require 'sinatra'

get '/hello' do
  content_type :json
  { 
    verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
    notation: "John 3:16 ESV" 
  }.to_json
end

get '/votd' do
  content_type :json
  { 
    verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
    notation: "John 3:16 ESV" 
  }.to_json
end



