require 'spec_helper'

RSpec.describe 'Route endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }
  let!(:journey1) { create(:journey, annual_miles: 10000) }
  let!(:journey2) { create(:journey, annual_miles: 20000) }
  let!(:commitment) { create(:commitment, user: user, journey: journey1) }
  let!(:route) { create(:route, user: user, commitment: commitment, mileage: 12000) }

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

  describe 'PATCH /user/routes' do
    # let(:route) { create(:route, user: user) }

    it 'requires the auth header' do
      patch "/user/routes/#{route.id}", {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'updates the Route with correct mileage' do
      patch "/user/routes", { id: route.id, mileage: 150, stop: false }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['mileage']).to eq(150)
    end

    it 'updates the Route with correct seconds' do
      patch "/user/routes", { id: route.id, mileage: 150, stop: false }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['seconds']).to eq(0)
    end

    it 'stops the Route' do
      patch "/user/routes", { id: route.id, mileage: 130, stop: true }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['stopped_at']).not_to be_nil
    end

    it 'marks the commitment as completed and updates to the next journey' do
      # Add mileage to exceed the current journey's annual miles
      patch "/user/routes", { id: route.id, mileage: 6000, stop: true }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['mileage']).to eq(6000)
      expect(parsed_response['data']['commitment_completed']).to be true
      expect(commitment.reload.journey).to eq(journey2)
    end

    it 'does not update the commitment if no next journey exists' do
      # Ensure there is no next journey
      journey2.destroy

      patch "/user/routes", { id: route.id, mileage: 6000, stop: true }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['mileage']).to eq(6000)
      expect(parsed_response['data']['commitment_completed']).to be false
      expect(commitment.reload.journey).to eq(journey1)
    end

    it 'does not mark the commitment as completed if total mileage is below the journey distance' do
      # Create a new commitment for the user and associate it with journey2
      new_commitment = create(:commitment, user: user, journey: journey2)

      # Create a new route associated with the new commitment
      new_route = create(:route, user: user, commitment: new_commitment, mileage: 0)

      # Perform the PATCH request on the new route
      patch "/user/routes", { id: new_route.id, mileage: 4000, stop: true }.to_json, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['route']['mileage']).to eq(4000)
      expect(parsed_response['data']['commitment_completed']).to be false
      expect(new_commitment.reload.journey).to eq(journey2)
    end
  end
end
