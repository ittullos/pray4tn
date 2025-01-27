# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Authentication middleware' do
  include AuthenticationSpecHelpers

  let(:app) { ->(env) { env } }

  describe 'Cognito' do
    subject { Authentication::Cognito.new(app) }
    let(:user) { create(:user) }
    let(:env) { Rack::MockRequest.env_for }
    let(:access_token_double) do
      instance_double(
        JsonWebToken,
        verify!: {
          'sub' => user.sub,
          'iss' => jwk[:issuer],
          'aud' => 'P4L-API'
        }
      )
    end

    before do
      allow(JsonWebToken).to receive(:new).and_call_original
      allow(JsonWebToken).to receive(:new).with('token').and_return(
        access_token_double
      )
    end

    context 'when the request bears a valid token' do
      before do
        env['HTTP_AUTHORIZATION'] = 'Bearer token'
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

      context 'when there is an ID token' do
        let(:id_token_double) do
          instance_double(
            JsonWebToken,
            verify!: { "email" => "gandalf@gmail.com" }
          )
        end

        before do
          env['X-ID-TOKEN'] = 'Bearer id_token'
          allow(JsonWebToken).to receive(:new).with('id_token').and_return(
            id_token_double
          )
        end

        it 'sets the email for the user' do
          allow(app).to receive(:call).and_return([200, {}, 'success'])

          response = subject.call(env)
          expect(response).to eq([200, {}, 'success'])
          expect(User.last.email).to include("isaac.tullos")
        end
      end
    end

    context 'when the request bears an invalid token' do
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

    context 'when the authorization header is for the wrong scheme' do
      before do
        env['HTTP_AUTHORIZATION'] = 'Basic token'
      end

      it 'denies access' do
        status, headers, body = subject.call(env)
        expect(status).to eq(401)
        expect(headers).to be_empty
        expect(JSON.parse(body[0])).to eq(unauthorized_response)
      end
    end

    context 'when the authorization header is empty' do
      before do
        env['HTTP_AUTHORIZATION'] = nil
      end

      it 'denies access' do
        status, headers, body = subject.call(env)
        expect(status).to eq(401)
        expect(headers).to be_empty
        expect(JSON.parse(body[0])).to eq(unauthorized_response)
      end
    end

    context 'when there is no authorization header' do
      it 'denies access' do
        status, headers, body = subject.call(env)
        expect(status).to eq(401)
        expect(headers).to be_empty
        expect(JSON.parse(body[0])).to eq(unauthorized_response)
      end
    end
  end
end
