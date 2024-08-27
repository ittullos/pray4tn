# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Authentication middleware' do
  include AuthenticationSpecHelpers

  let(:app) { ->(env) { env } }

  describe 'Cognito' do
    subject { Authentication::Cognito.new(app) }

    context 'when the request bears a valid token' do
      let(:json_web_token_double) { double(:json_web_token) }
      let(:env) { Rack::MockRequest.env_for }
      let(:user) { create(:user) }

      before do
        env['HTTP_AUTHORIZATION'] = 'Bearer token'
        allow(JsonWebToken).to receive(:new).with('token').and_return(json_web_token_double)
        allow(json_web_token_double).to receive(:verify!).and_return(
          {
            'data' => { 'sub' => user.sub },
            'iss' => jwk[:issuer],
            'aud' => 'P4L-API'
          }
        )
      end

      it 'allows access' do
        allow(app).to receive(:call).and_return([200, {}, 'success'])

        response = subject.call(env)
        expect(response).to eq([200, {}, 'success'])
      end

      it 'sets the user in the request env' do
        request_env = subject.call(env)
        expect(request_env[:user]).to eq(user)
      end
    end

    context 'when the request bears an invalid token' do
      let(:env) { Rack::MockRequest.env_for }

      before do
        env['HTTP_AUTHORIZATION'] = 'Bearer bad_token'
      end

      it 'denies access' do
        status, headers, body = subject.call(env)
        expect(status).to eq(401)
        expect(headers).to be_empty
        expect(JSON.parse(body[0])).to eq(unauthorized_response)
      end
    end
  end
end
