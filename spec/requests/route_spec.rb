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
    it 'requires the auth header' do
      patch "/user/routes/#{route.id}", {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    context 'when the mileage param is present' do
      it 'updates the route with correct mileage' do
        patch "/user/routes", { id: route.id, mileage: 6000, stop: false }.to_json, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response['data']['route']['mileage']).to eq(6000)
      end
    end

    context 'when the route is stopped' do
      context 'and the route completes the commitment distance' do
        it 'marks the commitment as completed and updates to the next journey' do
          route.update!(mileage: 21000)
          patch "/user/routes", { id: route.id, mileage: 2000, stop: true }.to_json, headers

          expect(last_response.status).to eq(200)
          expect(parsed_response['data']['meta']['commitment']['completed']).to be true
          expect(commitment.reload.journey).to eq(journey2)
        end
      end

      context 'and the route does NOT complete the commitment distance' do
        it 'does NOT mark the commitment as completed' do
          route.update!(mileage: 5000)
          patch "/user/routes", { id: route.id, mileage: 1000, stop: true }.to_json, headers

          expect(last_response.status).to eq(200)
          expect(parsed_response['data']['meta']['commitment']['completed']).to be false
          expect(commitment.reload.journey).to eq(journey1)
        end
      end
    end
  end
end
