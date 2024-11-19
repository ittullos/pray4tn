# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonWebToken do
  include AuthenticationSpecHelpers

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
    before do
      allow(AuthenticationSpecHelpers::MockJWKClient).to receive(:call).and_return({ keys: [jwk.export] })
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('COGNITO_DOMAIN_URL').and_return('cognito-idp.us-east-1.amazonaws.com')
    end

    context 'when the token is valid' do
      it 'returns the payload' do
        expect(subject.verify!).to eq(data)
      end
    end

    context 'when the token is invalid' do
      let(:token) do
        JWT.encode(data, OpenSSL::PKey::RSA.generate(1024), jwk[:alg], kid: jwk[:kid])
      end

      it 'raises an error' do
        expect { subject.verify! }.to raise_error(
          JWT::VerificationError, 'Signature verification failed'
        )
      end
    end
  end
end
