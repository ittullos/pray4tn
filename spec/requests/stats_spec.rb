require 'spec_helper'

RSpec.describe 'Stats endpoint', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { authenticated }
  let(:journey) { create(:journey, annual_miles: 365, monthly_miles: 30,  weekly_miles: 7) }
  let(:commitment) { create(:commitment, user: user, journey_id: journey.id) }

  before do
    route1 = create(:route, user: user, mileage: 10, seconds: 100, commitment: commitment)
    route2 = create(:route, user: user, mileage: 20, seconds: 200, commitment: commitment)
    route3 = create(:route, user: user, mileage: 30, seconds: 300)
    create(:prayer, user: user, route: route1)
    create(:prayer, user: user, route: route2)
    create(:prayer, user: user, route: route3)
    create(:prayer, user: user)

  end

  describe 'GET /user/stats' do
    it 'returns all-time and commitment stats for the user' do
      get '/user/stats', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['total_distance']).to eq(60)
      expect(parsed_response['data']['total_prayers']).to eq(4)
      expect(parsed_response['data']['total_duration']).to eq(600)
      expect(parsed_response['data']['commitment_distance']).to eq(30)
      expect(parsed_response['data']['commitment_duration']).to eq(300)
      expect(parsed_response['data']['commitment_prayers']).to eq(2)
    end

    it 'returns the current journey for the user' do
      get '/user/stats', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['current_journey']).to eq(data_object_for(journey))
    end

    it 'returns zero stats for current commitment when there is no current commitment' do
      allow_any_instance_of(User).to receive(:current_commitment).and_return(nil)
      get '/user/stats', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response['data']['commitment_distance']).to eq(0)
      expect(parsed_response['data']['commitment_duration']).to eq(0)
      expect(parsed_response['data']['commitment_prayers']).to eq(0)
    end

  end
end
