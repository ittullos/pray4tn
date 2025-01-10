require 'spec_helper'

RSpec.describe 'Stats endpoint', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { authenticated }

  before do
    route1 = create(:route, user: user, mileage: 10, seconds: 100)
    route2 = create(:route, user: user, mileage: 20, seconds: 200)
    route3 = create(:route, user: user, mileage: 30, seconds: 300)
    create(:prayer, user: user, route: route1)
    create(:prayer, user: user, route: route2)
    create(:prayer, user: user, route: route3)
  end

  describe 'GET /user/stats' do
    it 'returns the all-time stats for the user' do
      get '/user/stats', {}, headers

      expect(last_response.status).to eq(200)
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['data']['total_distance']).to eq(60)
      expect(parsed_response['data']['total_prayers']).to eq(3)
      expect(parsed_response['data']['total_duration']).to eq(600)
    end
  end
end
