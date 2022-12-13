require './spec/spec_helper'

describe "User model - " do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end