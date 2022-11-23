require 'json'
require 'sinatra'
require 'mysql2'
require 'sequel'

before do
  if ENV["RACK_ENV"] == "dev"
    Sequel.connect(ENV["DB_DEV"])
    require './app/models/verse'
    DB.loggers << Logger.new($stdout)

  elsif ENV["RACK_ENV"] == "prod"
    Sequel.connect(:adapter => 'mysql2',
                   :host => (ENV["DB_HOST"]),
                   :port => 3306,
                   :user => 'admin',
                   :password => (ENV["DB_PWRD"]),
                   :database => (ENV["DB_NAME"]))
    require './models/verse'
    DB.loggers << Logger.new($stdout)
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
  @user = User.find(:email => "email3")
  @user.add_checkpoint(timestamp: Time.now.to_i,
                       lat:       params[:lat],
                       long:      params[:long],
                       type:      params[:type])


end