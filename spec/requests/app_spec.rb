# frozen_string_literal: true

require 'spec_helper'
require_relative '../../app/services/resident_list'

describe 'Pastor4Life API -' do
  include Rack::Test::Methods
  include ApiSpecHelpers
  include AuthenticationSpecHelpers

  let(:app) { Sinatra::Application }
  let!(:user) { authenticated }
  let!(:verse) do
    create(:verse, day: (Time.now.yday % 100) + 1, version: 'CSB')
  end
  let(:pdf_file) { Rack::Test::UploadedFile.new('spec/fixtures/sample.pdf', 'application/pdf') }

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

  describe 'POST /user/residents' do
    context 'when the file is valid' do
      before do
        allow(ResidentList::PDF).to receive(:new).and_return(
          instance_double('ResidentList::PDF', load_residents: ["isaac newton", "zac efron"])
        )
      end

      it 'creates a resident for each name in the file' do
        post '/user/residents', { file: pdf_file }, headers

        expect(last_response.status).to eq(200)
        expect(Resident.count).to eq(2)
      end
    end

    context 'when the file is invalid' do
      it 'returns an error' do
        post '/user/residents', { file: 'cat.gif' }, headers

        expect(last_response.status).to eq(500)
        expect(parsed_response).to eq({"errors" => "The provided file is not a PDF.", "data" => ""})
      end
    end
  end

  describe 'Error Handling' do
    before do
      allow(Verse).to receive(:verse_of_the_day).and_raise(StandardError, "blob")
    end

    it 'logs an error' do
      expect { get '/home', {}, headers }.to output(/blob/).to_stdout
    end

    it 'responds with a 500' do
      get '/home', {}, headers

      expect(last_response.status).to eq(500)
    end

    it 'returns a message' do
      get '/home', {}, headers

      expect(parsed_response).to eq({"errors" => "blob", "data" => ""})
    end
  end
end
