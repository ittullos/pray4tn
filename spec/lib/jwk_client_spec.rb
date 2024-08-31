# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JWKClient do
  let(:jwk_endpoint) { 'https://www.cognito-jwks.com/' }

  let!(:jwk_fetch_request) do
    stub_request(:get, jwk_endpoint)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: jwk_response_body, headers: {})
  end

  let(:jwk_response_body) do
    {
      'keys' => [
        {
          'alg' => 'RS256',
          'e' => 'AQAB',
          'kid' => 'key_id_1',
          'kty' => 'RSA',
          'n' => 'a_super_long_string',
          'use' => 'sig'
        },
        {
          'alg' => 'RS256',
          'e' => 'AQAB',
          'kid' => 'key_id_2',
          'kty' => 'RSA',
          'n' => 'another_super_long_string',
          'use' => 'sig'
        }
      ]
    }.to_json
  end

  let(:client) { JWKClient.instance }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[])
      .with('COGNITO_JWK_ENDPOINT')
      .and_return(jwk_endpoint)
    allow(ENV).to receive(:[])
      .with('COGNITO_JWK_REFRESH_INTERVAL')
      .and_return(3600)
    JWKClient.clear_cache!
  end

  after do
    JWKClient.clear_cache!
  end

  describe '.instance' do
    it 'returns the same instance when called multiple times' do
      instance1 = JWKClient.instance
      instance2 = JWKClient.instance
      expect(instance1).to eq(instance2)
    end
  end

  describe '#call' do
    it 'fetches the JWKs from a configured endpoint' do
      client.call
      expect(jwk_fetch_request).to have_been_requested
    end

    context 'when the key is not found' do
      it 'does not re-fetch the JWKS until enough time has elapsed' do
        client.call
        client.call({ kid_not_found: true })
        expect(jwk_fetch_request).to have_been_requested.once
      end

      it 're-fetches the JWKs if enough time has elapsed' do
        client.call

        # Simulate time passing
        allow(Time).to receive(:now).and_return(Time.now + 3601)

        client.call({ kid_not_found: true })
        expect(jwk_fetch_request).to have_been_requested.twice
      end
    end
  end

  describe '#clear_cache!' do
    it 'clears the JWKs and last fetch time' do
      client.call
      client.clear_cache!
      expect(client.jwks.keys).to be_empty
      expect(client.instance_variable_get(:@last_fetch_time)).to be_nil
    end
  end

  context 'when there are errors' do
    it 'raises an error when the ENV is not configured' do
      allow(ENV).to receive(:[]).with('COGNITO_JWK_ENDPOINT').and_return(nil)
      expect do
        # We need to force a new instance to be created to test this
        JWKClient.send(:new)
      end.to raise_error(::JWKClient::JWKClientError, 'JWK endpoint is not configured')
    end

    it 'raises an error when it cannot reach the identity provider' do
      stub_request(:get, jwk_endpoint).to_return(status: 500, body: 'Server is Down')

      expect { JWKClient.instance.call }.to raise_error(
        ::JWKClient::JWKClientFetchError,
        'Error fetching JWKS, status: 500, message: Server is Down'
      )
    end
  end

  describe 'thread safety' do
    it 'ensures only one thread fetches keys when cache is empty' do
      threads = Array.new(10) do
        Thread.new do
          JWKClient.instance.call
        end
      end

      threads.each(&:join)

      expect(jwk_fetch_request).to have_been_made.once
      expect(JWKClient.instance.jwks).to eq(JWT::JWK::Set.new(JSON.parse(jwk_response_body)['keys']))
    end
  end

  describe 'error handling' do
    it 'raises an error when the request fails' do
      stub_request(:get, jwk_endpoint)
        .to_return(status: 500, body: 'Server is Down')
        .then.to_return(status: 200, body: jwk_response_body)

      expect { JWKClient.instance.call }.to raise_error(
        ::JWKClient::JWKClientFetchError,
        'Error fetching JWKS, status: 500, message: Server is Down'
      )
    end
  end
end
