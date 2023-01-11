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
    require './app/models/settings'
    require './app/models/user_resident'
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
    require './models/settings'
    require './models/user_resident'
  end
end

post '/p4l/home' do
  @user_id = JSON.parse(request.body.read)["userId"].to_i
  if Checkpoint.user_checkpoints(@user_id).count > 1
    if Checkpoint.user_checkpoints(@user_id).most_recent.type != "stop"
      # User[@user_id].add_checkpoint(timestamp: Time.now.to_i,
      #                               lat:       Checkpoint.user_checkpoints(@user_id).most_recent.lat,
      #                               long:      Checkpoint.user_checkpoints(@user_id).most_recent.long,
      #                               type:      "stop")
    end
  end
  @verse = Verse.first
  content_type :json
  { 
    verse:    @verse.scripture,
    notation: @verse.notation,
    version:  @verse.version
  }.to_json
end

post '/p4l/checkpoint' do
  rng         = RandomNameGenerator.new(RandomNameGenerator::ROMAN)
  location    = JSON.parse(request.body.read)["checkpointData"]
  @user       = User[location["userId"].to_i]
  is_valid    = true
  prayer_name = ""
  distance    = 0.0
  if location["type"] == "heartbeat" && Checkpoint.user_checkpoints(@user.id).most_recent.type == "stop"
    is_valid = false
  end
  if is_valid
    @checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                        lat:       location["lat"].to_s,
                        long:      location["long"].to_s,
                        type:      location["type"])

    if @checkpoint.type == "prayer_start"
      sleep 10
      prayer_name = "#{rng.compose(3)} #{rng.compose(4)}"
    elsif @checkpoint.type == "prayer"
      prayer_name = "#{rng.compose(3)} #{rng.compose(4)}"
      # distance = @checkpoint.distance
    elsif @checkpoint.type == "heartbeat"
      distance = @checkpoint.distance
    elsif @checkpoint.type == "stop"
      distance = @checkpoint.distance
    end
  end

  content_type :json
  {
    prayerName: prayer_name,
    distance:   distance
  }.to_json
end

post '/p4l/login' do
  login_form_data = JSON.parse(request.body.read)["loginFormData"]
  email           = login_form_data["email"]
  password        = login_form_data["password"]
  user_id         = 0
  
  if User.find(email: email)
    @user = User.find(email: email)
    if (@user.password == password)
      user_id = @user.id
      response_status = "success"
    else
      response_status = "Invalid Password"
    end
  else
    response_status = "Invalid Email"
  end

  content_type :json
  { 
    userId:         user_id,
    responseStatus: response_status 
  }.to_json
end

post '/p4l/signup' do
  signup_form_data = JSON.parse(request.body.read)["signupFormData"]
  email            = signup_form_data["email"]
  password         = signup_form_data["password"]
  confirm_password = signup_form_data["confirmPassword"]
  user_id          = 0

  if User.find(email: email)
    response_status = "Email already in use"
  elsif password != confirm_password
    response_status = "Passwords do not match"
  else
    user_id         = User.insert(email: email, password: password)
    response_status = "success"
  end

  content_type :json
  { 
    userId:         user_id,
    responseStatus: response_status 
  }.to_json
end

post '/p4l/password_reset' do
  password_reset_form_data = JSON.parse(request.body.read)["passwordResetFormData"]
  email                    = password_reset_form_data["email"]
  password                 = password_reset_form_data["password"]
  confirm_password         = password_reset_form_data["confirmPassword"]
  user_id                  = 0

  if !User.find(email: email)
    response_status = "No account with that email address"
  elsif password != confirm_password
    response_status = "Passwords do not match"
  else
    @user          = User.find(email: email)
    @user.password = password
    @user.save

    user_id = @user.id
    response_status = "success"
  end

  content_type :json
  { 
    userId:         user_id,
    responseStatus: response_status 
  }.to_json
end

get '/p4l/settings' do
  @settings = Settings.last

  content_type :json
  { 
    s3Bucket:         @settings.s3_bucket_name,
    region:           @settings.region,
    accessKeyId:      @settings.access_key_id,
    secretAccessKey:  @settings.secret_access_key
  }.to_json
end