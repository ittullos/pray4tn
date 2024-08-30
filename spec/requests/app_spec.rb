# frozen_string_literal: true

require 'spec_helper'

describe 'Pastor4Life API -' do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }
  let!(:verse) do
    create(:verse, day: (Time.now.yday % 100) + 1, version: 'CSB')
  end

  describe 'GET /home' do
    it 'returns a verse' do
      get '/home', {}, headers

      expect(last_response.status).to eq(200)
      expect(parsed_response).to eq(data_object_for(verse))
    end
  end

  describe 'GET /devotionals' do
    context 'when the user is authenticated' do
      let!(:devotionals) { create_list(:devotional, 6) }

      it 'returns a list of devotionals' do
        get '/devotionals', {}, headers

        expect(last_response.status).to eq(200)
        expect(parsed_response).to eq(data_object_for(devotionals))
      end
    end

    context 'when the user is not authenticated' do
      let(:user) { create(:user) }

      it 'returns an unauthorized response' do
        get '/devotionals', {}, headers

        expect(last_response.status).to eq(401)
        expect(parsed_response).to eq(unauthorized_response)
      end
    end
  end
end
