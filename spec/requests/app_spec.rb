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
end
