require 'json'
require 'sinatra'
require 'mysql2'
require 'sequel'
require "sinatra/cors"

set :allow_origin, "*"
set :allow_methods, "GET,POST,DELETE,PATCH,OPTIONS"
set :allow_headers, "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since"
set :expose_headers, "location,link"

puts "RACK_ENV: #{ENV['RACK_ENV']}"

before do
  if ENV["RACK_ENV"] == "dev"
    DB ||= Sequel.connect(ENV["DB_DEV"])
    DB.loggers << Logger.new($stdout)
    require './app/models/verse'
    require './app/models/user'
    require './app/models/checkpoint'
    require './app/models/route'
    # require './app/models/settings'
    # require './app/models/user_resident'
    require './app/models/resident'
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
    # require './models/settings'
    # require './models/user_resident'
    require './models/resident'
  end
end

post '/p4l/home' do
  @user_id = JSON.parse(request.body.read)["userId"].to_i
  Checkpoint.close_last_route(@user_id)
  
  @verse = Verse.scan.first
  content_type :json
  { 
    verse:    @verse.scripture,
    notation: @verse.notation,
    version:  @verse.version
  }.to_json
end

post '/p4l/checkpoint' do
  checkpoint_data = JSON.parse(request.body.read)["checkpointData"]
  user_id         = checkpoint_data["userId"].to_i
  checkpoint = Checkpoint.new_checkpoint(checkpoint_data)

  if checkpoint
    if checkpoint.type == "prayer"
      prayer_name = UserResident.next_name(user_id)
    elsif checkpoint.type == "heartbeat" || checkpoint.type == "stop"
      distance = checkpoint.distance
    end
  end

  content_type :json
  {
    prayerName: prayer_name || "",
    distance:   distance || 0.0
  }.to_json
end

post '/p4l/login' do
  login_form_data = JSON.parse(request.body.read)["loginFormData"]
  email           = login_form_data["email"]
  password        = login_form_data["password"]
  
  if User.find(email: email)
    user = User.find(email: email)
    if (user.password == password)
      user_id = user.id
      response_status = "success"
    else
      response_status = "Invalid Password"
    end
  else
    response_status = "Invalid Email"
  end

  content_type :json
  { 
    userId:         user_id || 0,
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
    user_id         = User.new_user(email: email, password: password)
    response_status = "success"
  end

  content_type :json
  { 
    userId:         user_id || 0,
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
    userId:         user.id || 0,
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