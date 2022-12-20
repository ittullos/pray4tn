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
    DB ||= Sequel.connect(ENV["DB_DEV"])
    DB.loggers << Logger.new($stdout)
    require './app/models/verse'
    require './app/models/user'
    require './app/models/checkpoint'
    require './app/models/route'
  elsif ENV["RACK_ENV"] == "prod"
    DB ||= Sequel.connect(:adapter => 'mysql2',
                   :host => (ENV["DB_HOST"]),
                   :port => 3306,
                   :user => 'admin',
                   :password => (ENV["DB_PWRD"]),
                   :database => (ENV["DB_NAME"]))
    DB.loggers << Logger.new($stdout)
    require './models/verse'
    require './models/user'
    require './models/checkpoint'
    require './models/route'
  end

end

get '/p4l/home' do
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
  location = JSON.parse(request.body.read)["checkpointData"]
  puts "LOCATION: #{location}"
  @checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                       lat:       location["lat"].to_s,
                       long:      location["long"].to_s,
                       type:      location["type"])
  if (@checkpoint.type == "start") 
    content_type :json
    { 
      distance: 0.0
    }.to_json
  else 
    content_type :json
    { 
      distance: @checkpoint.distance
    }.to_json
  end
end

post '/p4l/login' do
  login_form_data = JSON.parse(request.body.read)["loginFormData"]
  puts "LOGIN FORM DATA: #{login_form_data}"
  content_type :json
  { 
    token: "login succes"
  }.to_json
end