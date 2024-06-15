require 'spec_helper'

RSpec.describe 'ResidentList endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { create(:user) }
  let!(:resident_list) { create(:resident_list, :with_residents, user: user) }
  let(:headers) do
    {
      'P4L-email' => user.email
    }
  end

  describe 'GET /user/resident-list/:id' do
    context 'when the User owns the ResidentList' do
      it 'returns the ResidentList' do
        get "/user/resident-list/#{resident_list.id}", {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match(data_object_for(resident_list))
      end

      it 'returns an error response if the ResidentList does not exist' do
        get "/user/resident-list/#{ResidentList.maximum(:id) + 1}", {}, headers

        expect(last_response.status).to eq(404)
        expect(parsed_response).to match('message' => 'Not found')
      end

      it 'returns an error response when the email is not sent' do
        get "/user/resident-list/#{resident_list.id}", {}, {}

        expect(last_response.status).to eq(400)
        expect(last_response.body).to be_empty
      end
    end

    context 'when the User does not own the ResidentList' do
      it 'returns an error response' do
        not_the_user_email = { 'P4L-email' => 'vladimir@hacking.ru' }
        get "/user/resident-list/#{resident_list.id}", {}, not_the_user_email

        expect(last_response.status).to eq(404)
        expect(parsed_response).to match('message' => 'Not found')
      end
    end
  end
end
