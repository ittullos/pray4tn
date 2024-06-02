require 'spec_helper'

RSpec.describe 'User endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { create(:user) }
  let(:headers) do
    {
      'P4L-email' => user.email
    }
  end

  describe 'GET /user' do
    it 'returns the User with the given email' do
      get '/user', {}, headers

      expect(last_response.status).to eq(200)

      expect(parsed_response).to match(data_object_for(user))
    end

    it 'returns an error when the email is not sent' do
      get '/user', {}, {}

      expect(last_response.status).to eq(400)
      expect(last_response.body).to be_empty
    end
  end
end
