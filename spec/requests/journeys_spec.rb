require 'spec_helper'

RSpec.describe 'Journey endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }

  describe 'GET /journeys' do
    let!(:journeys) do
      create_list(:journey, 2)
    end

    it 'requires authentication' do
      get '/journeys', {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'returns a list of Journeys' do
      get '/journeys', {}, headers

      expect(parsed_response).to include(
        'data' => data_objects_for_multiple(journeys)
      )
    end
  end
end
