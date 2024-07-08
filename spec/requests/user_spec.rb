require 'spec_helper'

RSpec.describe 'User endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { create(:user) }
  let(:alice) { create(:resident, name: 'Alice the first', position: 1) }
  let(:bob) { create(:resident, name: 'Bob the second', position: 2) }
  let(:chad) { create(:resident, name: 'Chad the third', position: 3) }
  let(:headers) do
    {
      'P4L-email' => user.email
    }
  end

  describe 'GET /user' do
    it 'returns the User with the given email' do
      get '/user', {}, headers

      expect(last_response.status).to eq(200)

      expect(parsed_response).to match(data_object_for(user))
    end

    it 'returns an error when the email is not sent' do
      get '/user', {}, {}

      expect(last_response.status).to eq(400)
      expect(last_response.body).to be_empty
    end
  end

  describe 'GET /user/residents' do
    context 'when there are no Residents' do
      it 'returns an empty response' do
        get '/user/residents', {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match([])
      end
    end

    context 'when the User owns the Residents' do
      let!(:residents) { create_list(:resident, 3, user:) }

      it 'returns the Residents ordered by position' do
        get '/user/residents', {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match_array(data_objects_for_multiple(residents))

        resident_positions = parsed_response.map do |resident|
          resident.fetch('position')
        end
        expect(resident_positions).to eq(residents.map(&:position).sort)
      end

      it 'returns an error response when the email is not sent' do
        get '/user/residents', {}, {}

        expect(last_response.status).to eq(400)
        expect(last_response.body).to be_empty
      end

      it 'returns an empty response if the wrong email is sent' do
        not_the_user_email = { 'P4L-email' => 'vladimir@hacking.ru' }
        get '/user/residents', {}, not_the_user_email

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match([])
      end
    end
  end

  describe 'GET /user/residents/' do
    let!(:user) { create(:user, residents: [alice, bob, chad]) }

    it 'requires the email header' do
      get "/user/residents/#{alice.id}", {}, {}

      expect(last_response.status).to eq(400)
      expect(last_response.body).to be_empty
    end

    it 'returns the resident' do
      get "/user/residents/#{alice.id}", {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(alice))
    end
  end

  describe 'GET /user/residents/next-resident' do
    let(:user) { create(:user, residents: [alice, bob, chad]) }

    it 'returns the first Resident if there are no Prayers' do
      get '/user/residents/next-resident', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(alice))
    end

    it 'returns the next resident in the list' do
      create(:prayer, user:, resident: alice)

      get '/user/residents/next-resident', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(bob))

      create(:prayer, user:, resident: bob)
      get '/user/residents/next-resident', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(chad))
    end

    it 'returns the first resident when there are equal numbers of Prayers' do
      create(:prayer, user:, resident: alice)
      create(:prayer, user:, resident: bob)
      create(:prayer, user:, resident: chad)

      get '/user/residents/next-resident', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(alice))
    end
  end
end
