require 'json'
require 'sinatra'
require "sinatra/cors"
# require "./spec/dinodb"


set :allow_origin, "*"
set :allow_methods, "GET,POST,DELETE,PATCH,OPTIONS"
set :allow_headers, "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since"
set :expose_headers, "location,link"

puts "RACK_ENV: #{ENV['RACK_ENV']}"

before do
  if ENV["RACK_ENV"] == "dev"
    Aws.config.update(
      endpoint: 'http://localhost:8000'
    )
    
    require './app/models/verse'
    require './app/models/user'
    require './app/models/checkpoint'
    require './app/models/route'
    require './app/models/user_resident'
  elsif ENV["RACK_ENV"] == "prod"
    require './models/verse'
    require './models/user'
    require './models/checkpoint'
    require './models/route'
    require './models/user_resident'
  end
end

post '/p4l/home' do
  puts "HOME!!!"
  user_id = JSON.parse(request.body.read)["userId"]
  puts "HOME:user_id:#{user_id}"
  
  Checkpoint.close_last_route(user_id)
  
  puts "HOME:Start scanning Verse"
  verse = Verse.scan.first if Verse.table_exists?
  puts "HOME:Stop scanning Verse"

  content_type :json
  { 
    verse:    verse && verse.scripture,
    notation: verse && verse.notation,
    version:  verse && verse.version
  }.to_json
end

post '/p4l/checkpoint' do
  checkpoint_data = JSON.parse(request.body.read)["checkpointData"]
  user_id         = checkpoint_data["user_id"]

  if checkpoint_data["type"] == "prayer"
    resident = UserResident.next_resident(user_id)
    prayer_name = resident ? resident.name : ""
    checkpoint_data["match_key"] = resident.match_key if resident
  end

  checkpoint = Checkpoint.new_checkpoint(checkpoint_data)

  if checkpoint
    if checkpoint.type == "heartbeat" || checkpoint.type == "stop"
      distance = checkpoint.distance
    end
  end

  content_type :json
  {
    prayerName: prayer_name,
    distance:   distance || 0.0
  }.to_json
end

post '/p4l/login' do
  puts "App:login:initial call"
  login_form_data = JSON.parse(request.body.read)["loginFormData"]
  email           = login_form_data["email"]
  password        = login_form_data["password"]
  
  if User.find(email: email)
    puts "App:login:before User.find"
    user = User.find(email: email)
    puts "App:login:after User.find"
    if (user.password == password)
      response_status = "success"
    else
      response_status = "Invalid Password"
    end
  else
    response_status = "Invalid Email"
  end

  content_type :json
  { 
    userId:         email || 0,
    responseStatus: response_status 
  }.to_json
end

post '/p4l/signup' do
  signup_form_data = JSON.parse(request.body.read)["signupFormData"]
  email            = signup_form_data["email"]
  password         = signup_form_data["password"]
  confirm_password = signup_form_data["confirmPassword"]

  if User.find(email: email)
    response_status = "Email already in use"
  elsif password != confirm_password
    response_status = "Passwords do not match"
  else
    User.new_user(email: email, password: password)
    response_status = "success"
  end

  content_type :json
  { 
    userId:         email || 0,
    responseStatus: response_status 
  }.to_json
end

post '/p4l/password_reset' do
  password_reset_form_data = JSON.parse(request.body.read)["passwordResetFormData"]
  user                     = User.find(email: password_reset_form_data["email"])
  password                 = password_reset_form_data["password"]
  confirm_password         = password_reset_form_data["confirmPassword"]

  if !user 
    response_status = "No account with that email address"
  elsif password != confirm_password
    response_status = "Passwords do not match"
  else
    user.reset_password(password)
    response_status = "success"
  end

  content_type :json
  { 
    userId:         email || 0,
    responseStatus: response_status 
  }.to_json
end

get '/p4l/settings' do
  content_type :json
  { 
    s3Bucket:         ENV["RESIDENT_NAMES_BUCKET"],
    region:           ENV["REGION"],
    accessKeyId:      ENV["ACCESS_KEY_ID"],
    secretAccessKey:  ENV["SECRET_ACCESS_KEY"]
  }.to_json
end