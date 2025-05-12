require 'spec_helper'

RSpec.describe 'Route endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }

  describe 'POST /user/routes' do
    it 'requires the auth header' do
      post '/user/routes', {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'creates a Route' do
      expect do
        post '/user/routes', {}, headers
      end.to change { Route.count }.by(1)
      expect(last_response.status).to eq(201)
      expect(parsed_response).to include(
        "data" => data_object_for(Route.last)
      )
    end

    it 'creates a Route with a nil commitment' do
      allow_any_instance_of(User).to receive(:current_commitment).and_return(nil)
      post '/user/routes', {}, headers

      expect(last_response.status).to eq(201)
      expect(parsed_response['data']['commitment_id']).to be_nil
      expect(parsed_response['data']['user_id']).to eq(user.id)
    end
  end

  describe 'PATCH /user/routes/:id' do
    let(:route) { create(:route, user: user) }

    it 'requires the auth header' do
      patch "/user/routes/#{route.id}", {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'updates the Route' do
      patch "/user/routes", { id: route.id, mileage: 130, stop: false }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to include(
        "data" => data_object_for(route.reload)
      )
      expect(route.mileage).to eq(130)
    end

    it 'updates the Route with correct mileage' do
      patch "/user/routes", { id: route.id, mileage: 150, stop: false }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['mileage']).to eq(150)
    end

    it 'updates the Route with correct seconds' do
      patch "/user/routes", { id: route.id, mileage: 150, stop: false }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['seconds']).to eq(0)
    end

    it 'stops the Route' do
      patch "/user/routes", { id: route.id, mileage: 130, stop: true }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to include(
        "data" => data_object_for(route.reload)
      )
      expect(route.stopped_at).not_to be_nil
    end
  end
end
