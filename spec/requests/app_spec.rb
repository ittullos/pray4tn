require './spec/spec_helper'

describe "Pastor4Life API -" do
  include Rack::Test::Methods
  include ApiSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { create(:user) }

  let(:headers) do
    {
      'P4L-email' => user.email
    }
  end

  describe 'GET /home' do
    include ActiveSupport::Testing::TimeHelpers
    it 'returns the correct verse' do

      # year, month, day, hour, minute, second
      travel_to Time.local(2024, 4, 9, 1, 0, 0) do
        verse = create(:verse, day: 1)
        get '/home', {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match(data_object_for(verse))

      end

      travel_to Time.local(2024, 4, 10, 1, 0, 0) do
        get '/home', {}, headers

        expect(last_response.status).to eq(200)
      end
    end
  end
end
