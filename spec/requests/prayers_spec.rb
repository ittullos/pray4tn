require 'spec_helper'

RSpec.describe 'Prayer endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { authenticated }

  describe 'POST /prayers' do
    let!(:resident) { create(:resident, user:) }

    let(:valid_params) do
      {
        resident_id: resident.id
      }
    end

    it 'requires the email header' do
      post '/prayers', valid_params, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response['errors']).to include('Unauthorized')
    end

    it 'creates a Prayer' do
      expect do
        post '/prayers', valid_params, headers
      end.to change { Prayer.count }.by(1)
    end

    it 'returns the next Resident for the User' do
      bob = create(:resident, user:, position: resident.position + 1)

      post '/prayers', valid_params, headers
      expect(last_response.status).to eq(201)

      expect(parsed_response).to include(
        data_object_for(Prayer.last).merge('next_resident_id' => bob.id)
      )
    end

    it 'returns an error response for a malformed request' do
      invalid_params = { taco_id: resident.id }

      post '/prayers', invalid_params, headers

      expect(last_response.status).to eq(400)
      expect(parsed_response['errors']).to include('Missing param: resident_id')
    end

    it 'returns an error response for invalid data' do
      invalid_params = { resident_id: Resident.maximum(:id) + 1 }

      post '/prayers', invalid_params, headers

      expect(last_response.status).to eq(422)
      expect(parsed_response['errors']).to include("Validation failed: Resident can't be blank")
    end
  end
end
