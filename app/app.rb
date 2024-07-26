# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cors'
require_relative './models'

set :database_file, '../config/database.yml'

set :allow_origin, '*'
set :allow_methods, 'GET,POST,DELETE,PATCH,OPTIONS'
set :allow_headers,
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since, P4L-email'
set :expose_headers, 'location,link'

puts "RACK_ENV: #{ENV['RACK_ENV']}"

get '/user' do
  email = request.fetch_header('P4L-email')
  user = User.find_by_email(email)

  content_type :json
  user.to_json

rescue KeyError
  status 400
  body {}
end

get '/user/residents' do
  email = request.fetch_header('P4L-email')
  user = User.find_by_email(email)

  residents = Resident.where(user_id: user&.id)

  content_type :json
  residents.to_json

rescue KeyError
  status 400
  body {}
end

get '/user/residents/next-resident' do
  email = request.fetch_header('P4L-email')
  user = User.find_by_email(email)

  # TODO: Look at eager loading here. We might be able to grab the resident for
  # the last Prayer at the same time, or use a plain AR query to grab the next
  # Resident without instantiating the objects in between:
  # user.residents.where('position > ?', last_prayer.resident.position).limit(1).first
  last_prayer = Prayer.where(user_id: user&.id).order(recorded_at: :desc).limit(1).first
  next_resident = if last_prayer.nil?
                    user.residents.limit(1).first
                  else
                    last_prayer.resident.next_resident
                  end

  content_type :json
  next_resident.to_json

rescue KeyError
  status 400
  body {}
end

get '/user/residents/:id' do
  email = request.fetch_header('P4L-email')
  user = User.find_by_email(email)

  resident = Resident.find_by(id: params[:id], user_id: user&.id)

  content_type :json
  resident.to_json

rescue KeyError
  status 400
  body {}
end

get '/home' do
  email = request.get_header('HTTP_P4L_EMAIL')
  user = User.find_by_email(email)
  verse = Verse.verse_of_the_day

  content_type :json
  verse.to_json

rescue KeyError
  status 400
  body {}
end
