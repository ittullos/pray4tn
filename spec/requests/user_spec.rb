require 'spec_helper'

RSpec.describe 'User endpoints', :request do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated(create(:user, residents:)) }
  let(:alice) { create(:resident, name: 'Alice the first', position: 1) }
  let(:bob) { create(:resident, name: 'Bob the second', position: 2) }
  let(:chad) { create(:resident, name: 'Chad the third', position: 3) }
  let(:residents) { [alice, bob, chad] }

  describe 'GET /user' do
    it 'returns the User with the given email' do
      get '/user', {}, headers

      expect(last_response.status).to eq(200)

      expect(parsed_response).to match(data_object_for(user))
    end

    it 'returns an error when the email is not sent' do
      get '/user', {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response).to eq(unauthorized_response)
    end
  end

  describe 'GET /user/residents' do
    context 'when there are no Residents' do
      let(:residents) { [] }

      it 'returns an empty response' do
        get '/user/residents', {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to match([])
      end
    end

    context 'when the User owns the Residents' do
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

        expect(last_response.status).to eq(401)
        expect(parsed_response).to eq(unauthorized_response)
      end

      it 'returns an unauthorized response if the wrong email is sent' do
        not_the_user_email = { 'HTTP_P4L_EMAIL' => 'vladimir@hacking.ru' }
        get '/user/residents', {}, not_the_user_email

        expect(last_response.status).to eq(401)
        expect(parsed_response).to eq(unauthorized_response)
      end
    end
  end

  describe 'GET /user/residents/' do
    it 'requires the email header' do
      get "/user/residents/#{alice.id}", {}, {}

      expect(last_response.status).to eq(401)
      expect(parsed_response).to eq(unauthorized_response)
    end

    it 'returns the resident' do
      get "/user/residents/#{alice.id}", {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to match(data_object_for(alice))
    end
  end

  describe 'GET /user/residents/next-resident' do
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
