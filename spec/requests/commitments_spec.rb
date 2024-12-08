require 'spec_helper'

RSpec.describe 'Commitments endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }

  describe 'POST /commitments' do
    let!(:journey) { create(:journey) }
    let(:valid_params) do
      {
        journey_id: journey.id
      }
    end

    it 'requires authentication' do
      post '/user/commitments', valid_params, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'creates a Commitment' do
      expect do
        post '/user/commitments', valid_params, headers
      end.to change { Commitment.count }.by(1)
    end

    it 'returns an error response for a malformed request' do
      invalid_params = { burrito_id: journey.id }

      post '/user/commitments', invalid_params, headers

      expect(last_response.status).to eq(400)
      expect(parsed_response['errors']).to include('Missing param: journey_id')
    end

    it 'returns an error response for invalid data' do
      invalid_params = { journey_id: Journey.maximum(:id) + 1 }

      post '/user/commitments', invalid_params, headers

      expect(last_response.status).to eq(422)
      expect(parsed_response['errors']).to include("Validation failed: Journey can't be blank")
    end
  end
end
