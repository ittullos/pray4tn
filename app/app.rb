# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cors'
require_relative './models'
require_relative './middleware/authentication'
require_relative './services/resident_list'
require_relative './lib/json_web_token'
require_relative './lib/jwk_client'

set :database_file, '../config/database.yml'

set :allow_origin, '*'
set :allow_methods, 'GET,POST,DELETE,PATCH,OPTIONS'
set :allow_headers,
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since, HTTP_AUTHORIZATION'
set :expose_headers, 'location,link'

puts "RACK_ENV: #{ENV['RACK_ENV']}"

configure :development, :test do
  log_dir = File.expand_path('../log', __dir__)
  FileUtils.mkdir_p(log_dir) unless File.directory?(log_dir)

  log_file_path = File.join(log_dir, "#{settings.environment}.log")
  log_file = File.new(log_file_path, 'a+')
  log_file.sync = true
  use Rack::CommonLogger, log_file
  set :logging, Logger::DEBUG
  ActiveRecord::Base.logger = Logger.new(log_file)
end

configure :production do
  use Rack::CommonLogger, $stdout
  set :logging, Logger::INFO
  ActiveRecord::Base.logger = Logger.new($stdout)
end

use Authentication::Cognito

before do
  content_type :json
end

get '/home' do
  verse = Verse.verse_of_the_day("CSB")
  status 200
  { data: verse }.to_json
end

post '/user/commitments' do
  journey_id = parsed_params.fetch('journey_id')
  commitment = Commitment.new(journey_id: journey_id, user_id: user_from_token&.id)
  commitment.save!

  status 201
  { data: commitment }.to_json
end

get '/devotionals' do
  devotionals = Devotional.all
  status 200
  { data: devotionals }.to_json
end

get '/journeys' do
  status 200
  { data: Journey.all }.to_json
end

post '/user/residents' do
  unless params[:file] && params[:file]['tempfile']
    status 400
    return { errors: 'File is required', data: '' }.to_json
  end

  file = params[:file]['tempfile']
  user = user_from_token

  begin
    residents = ResidentList::PDF.new(file).load_residents

    residents.each do |resident|
      Resident.find_or_create_by(name: resident, user_id: user.id)
    end

    status 200
    { data: residents, errors: '' }.to_json
  rescue ResidentList::PDF::InvalidFileFormatError => e
    status 400
    { errors: e.message, data: '' }.to_json
  rescue ArgumentError => e
    status 400
    { errors: e.message, data: '' }.to_json
  rescue StandardError => e
    status 500
    { errors: e.message, data: '' }.to_json
  end
end

get '/user' do
  status 200
  { data: user_from_token }.to_json
end

get '/user/residents' do
  residents = Resident.where(user_id: user_from_token&.id)
  status 200
  { data: residents }.to_json
end

# Step 1, happens at the beginning of a route
# you get back the Resident information to make a Prayer
get '/user/residents/next-resident' do
  # TODO: Look at eager loading here. We might be able to grab the resident for
  # the last Prayer at the same time, or use a plain AR query to grab the next
  # Resident without instantiating the objects in between:
  # user.residents.where('position > ?', last_prayer.resident.position).limit(1).first
  last_prayer = Prayer.where(user_id: user_from_token&.id).order(recorded_at: :desc).limit(1).first
  next_resident = if last_prayer.nil?
                    user_from_token.residents.limit(1).first
                  else
                    last_prayer.resident.next_resident
                  end
  status 200
  { data: next_resident }.to_json
end

get '/user/residents/:id' do
  resident = Resident.find_by(id: params[:id], user_id: user_from_token&.id)
  status 200
  { data: resident }.to_json
end

# Step 2
# call this for the resident, it creates a Prayer for the Resident based on the
# resident_id given
post '/prayers' do
  resident_id = parsed_params.fetch('resident_id')
  prayer = Prayer.new(resident_id:, user_id: user_from_token&.id, recorded_at: Time.current)
  prayer.save!

  next_resident = prayer.resident.next_resident

  status 201
  { data: prayer.attributes.merge('next_resident' => next_resident) }.to_json
end

post '/user/routes' do
  user = user_from_token

  route = Route.create!(
    user: user,
    commitment: user&.current_commitment,
    started_at: Time.current)

  status 201
  { data: route }.to_json
end

patch '/user/routes' do
  route = Route.find(parsed_params.fetch('id'))

  if parsed_params.fetch('stop')
    route.stopped_at = Time.current
  end

  route.mileage = parsed_params.fetch('mileage')
  route.save!

  status 200
  { data: route }.to_json
end

get '/user/stats' do
  user = user_from_token
  stats = user.stats
  status 200
  { data: stats }.to_json
end

error ActiveRecord::RecordInvalid do |error|
  status 422
  body [{ errors: error.message.to_s }.to_json]
end

error KeyError do |error|
  status 400
  body [{ errors: ["Missing param: #{error.key}"] }.to_json]
end

error StandardError do |error|
  puts "500 - #{error.message}"
  status 500
  body [{ data: '', errors: error.message }.to_json]
end

helpers do
  def parsed_params
    request.body.rewind  # Ensure the body is readable
    body = request.body.read
    return {} if body.empty?

    JSON.parse(body)
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end
end

private

def user_from_token
  @user_from_token ||= env[:user]
end
