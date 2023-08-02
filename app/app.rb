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
    require './app/models/devotional'
    require './app/models/journey'
    require './app/models/commitment'
  elsif ENV["RACK_ENV"] == "prod"
    require './models/verse'
    require './models/user'
    require './models/checkpoint'
    require './models/route'
    require './models/user_resident'
    require './models/devotional'
    require './models/journey'
    require './models/commitment'
  end
end

post '/p4l/home' do
  user_id = JSON.parse(request.body.read)["userId"]
  Checkpoint.close_last_route(user_id)
  
  verses = Verse.scan if Verse.table_exists?
  time = Time.new
  day = time.yday % 100
  verse = verses.select {|v| v.day == day}
  
  verse = verses.select {|v| v.day == 1} if verse.empty?
  content_type :json
  { 
    verse:    verse && verse.first.scripture,
    notation: verse && verse.first.notation,
    version:  verse && verse.first.version
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

get '/p4l/devotionals' do
  devotionals_array = []
  Devotional.scan.each do |item|
    devotional = {}
    devotional["id"] = item.id
    devotional["title"] = item.title
    devotional["url"] = item.url
    devotional["img_url"] = item.img_url
    devotionals_array.push(devotional)
  end
  devotionals_array.sort_by! { |devo| devo["id"] }
  content_type :json
  {
    devotionals: devotionals_array
  }.to_json
end

post '/p4l/journeys' do
  user_id = JSON.parse(request.body.read)["userId"]
  if user_id.include? '"'
    user_id.delete! '\"'
  end

  user = User.find(email: user_id)
  journeys_array = []
  Journey.scan.each do |item|
    journey = {}
    journey["title"] = item.title
    journey["annual_miles"] = item.annual_miles
    journey["monthly_miles"] = item.monthly_miles
    journey["weekly_miles"] = item.weekly_miles
    journeys_array.push(journey)
  end
  journeys_array.sort_by! { |journey| journey["annual_miles"] }
  commitment = "false"
  if user.commitment_id != 0 
    commitment = "true"
  end

  content_type :json
  {
    journeys: journeys_array,
    commitment: commitment
  }.to_json
end

post '/p4l/commitment' do
  commitment_data = JSON.parse(request.body.read)["commitmentData"]
  user = User.find(email: commitment_data["user_id"])
  new_commit = Commitment.new_commitment(commitment_data)
  user.commitment_id = new_commit.commitment_id
  user.save!
end

post '/p4l/stats' do
  user_id = JSON.parse(request.body.read)["userId"]
  if user_id.include? '"'
    user_id.delete! '\"'
  end

  user = User.find(email: user_id)

  if !user.commitment_id || user.commitment_id == 0
    content_type :json
    {
      title: "No commitment"
    }.to_json
  else
    stats = user.get_stats
    content_type :json
    {
      title: stats[:title],
      targetMiles: stats[:target_miles],
      progressMiles: stats[:progress_miles],
      prayers: stats[:prayers],
      seconds: stats[:seconds],
      targetDate: stats[:target_date],
      commitDate: stats[:commit_date]
    }.to_json
  end
end

post '/p4l/add_mileage' do
  mileage_data = JSON.parse(request.body.read)["addMileageData"]

  if mileage_data["userId"].include? '"'
    mileage_data["userId"].delete! '\"'
  end

  user = User.find(email: mileage_data["userId"])
  mileage = mileage_data["mileage"]
  route = Route.find(id: Checkpoint.last_checkpoint(user.email).route_id)
  route.mileage += (mileage * 1000)
  route.save
end