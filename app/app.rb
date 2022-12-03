require 'json'
require 'sinatra'
require 'mysql2'
require 'sequel'
require "sinatra/cors"

set :allow_origin, "*"
set :allow_methods, "GET,POST,DELETE,PATCH,OPTIONS"
set :allow_headers, "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since"
set :expose_headers, "location,link"

before do
  if ENV["RACK_ENV"] == "dev"
    DB = Sequel.connect(ENV["DB_DEV"])
    
    DB.loggers << Logger.new($stdout)

  elsif ENV["RACK_ENV"] == "prod"
    DB = Sequel.connect(:adapter => 'mysql2',
                   :host => (ENV["DB_HOST"]),
                   :port => 3306,
                   :user => 'admin',
                   :password => (ENV["DB_PWRD"]),
                   :database => (ENV["DB_NAME"]))
    DB.loggers << Logger.new($stdout)
  end
  require './app/models/verse'
  require './app/models/user'
  require './app/models/checkpoint'
  require './app/models/route'

end

get '/p4l/home' do
  # pry.byebug
  @verse = Verse.first



  content_type :json
  { 
    verse: @verse.scripture,
    notation: @verse.notation,
    version: @verse.version
  }.to_json
end

post '/p4l/checkpoint' do
  @user = User.first
  packet = JSON.parse(request.body.read)["checkpointData"]

  puts "packet: #{packet}"
  
  @user.add_checkpoint(timestamp: Time.now.to_i,
                       lat:       packet["lat"].to_s,
                       long:      packet["long"].to_s,
                       type:      packet["type"],
                       distance:  packet["distance"].to_f)

  200
end