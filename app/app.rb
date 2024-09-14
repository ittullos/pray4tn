# frozen_string_literal: true

require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cors'
require_relative './models'
require_relative './middleware/authentication'

set :database_file, '../config/database.yml'

set :allow_origin, '*'
set :allow_methods, 'GET,POST,DELETE,PATCH,OPTIONS'
set :allow_headers,
    'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since, HTTP_P4L_EMAIL'
set :expose_headers, 'location,link'

puts "RACK_ENV: #{ENV['RACK_ENV']}"

use Authentication::Cognito

before do
  content_type :json
end

get '/home' do
  verse = Verse.verse_of_the_day("CSB")

  content_type :json
  verse.to_json
end

get '/devotionals' do
  devotionals = Devotional.all

  content_type :json
  devotionals.to_json
end

get '/user' do
  user_from_token.to_json
end

get '/user/residents' do
  residents = Resident.where(user_id: user_from_token&.id)

  residents.to_json
end

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

  next_resident.to_json
end

get '/user/residents/:id' do
  resident = Resident.find_by(id: params[:id], user_id: user_from_token&.id)

  resident.to_json
end

post '/prayers' do
  resident_id = params.fetch('resident_id')
  prayer = Prayer.new(resident_id:, user_id: user_from_token&.id, recorded_at: Time.current)
  prayer.save!

  next_resident = prayer.resident.next_resident

  status 201
  prayer.attributes.merge(
    { 'next_resident_id' => next_resident.id }
  ).to_json
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

private

def user_from_token
  @user_from_token ||= env[:user]
end
