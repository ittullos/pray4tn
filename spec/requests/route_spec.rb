require 'spec_helper'

RSpec.describe 'Route endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { authenticated }

  describe 'POST /user/routes' do
    it 'requires the auth header' do
      post '/user/routes', {}, headers

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'creates a Route' do
      expect do
        post '/user/routes', {}, user_token_header(user, { 'sub' => user.sub })
      end.to change { Route.count }.by(1)
      expect(last_response.status).to eq(200)
      expect(parsed_response).to include(
        "data" => data_object_for(Route.last)
      )
    end

    it 'creates a Route with a nil commitment' do
      allow_any_instance_of(User).to receive(:current_commitment).and_return(nil)
      post '/user/routes', {}, user_token_header(user, { 'sub' => user.sub })

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['commitment_id']).to be_nil
      expect(parsed_response['data']['user_id']).to eq(user.id)
    end
  end
end
