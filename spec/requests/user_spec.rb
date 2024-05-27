require 'spec_helper'

RSpec.describe 'User endpoints', :request do
  include Rack::Test::Methods

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

      parsed_json = JSON.parse(last_response.body)

      expect(parsed_json).to match(
        user.attributes.merge(
          { 'created_at' => user.created_at.in_time_zone("UTC").to_s,
            'updated_at' => user.updated_at.in_time_zone("UTC").to_s }
          # { 'created_at' => be_within(1.second).of(user.created_at.to_s),
          #   'updated_at' => be_within(1.second).of(user.updated_at.to_s) }
        )
      )
    end
  end
end
