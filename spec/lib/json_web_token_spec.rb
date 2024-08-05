# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonWebToken do
  let(:rsa_key) { OpenSSL::PKey::RSA.generate 1024 }
  let(:jwk) do
    desc_params = {
      kid: 'my-kid',
      se: 'sig',
      alg: 'RS256',
      issuer: 'cognito-idp.us-east-1.amazonaws.com'
    }
    JWT::JWK.new(rsa_key, desc_params)
  end
  let(:user) { create(:user) }
  let(:data) do
    {
      'data' => { 'sub' => user.sub },
      'iss' => jwk[:issuer],
      'aud' => 'P4L-API'
    }
  end
  let(:token) do
    JWT.encode(data, rsa_key, jwk[:alg], kid: jwk[:kid])
  end
  subject { described_class.new(token) }

  describe '#verify!' do
    context 'when the token is valid' do
      before do
        allow(JsonWebToken).to receive(:jwks).and_return({ keys: [jwk.export] })
      end

      it 'returns the payload' do
        expect(subject.verify!).to eq(data)
      end
    end
  end
end
