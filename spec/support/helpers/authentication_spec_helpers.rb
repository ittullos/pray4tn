# frozen_string_literal: true

require 'jwt'

module AuthenticationSpecHelpers
  def self.included(test)
    test.before do
      allow(JWKClient).to receive(:instance).and_return(MockJWKClient)
    end
  end

  @@rsa_key ||= OpenSSL::PKey::RSA.generate 1024

  def authenticated(user = FactoryBot.create(:user), token_payload = {})
    headers.merge!(user_token_header(user, token_payload))
    user
  end

  def headers
    @headers ||= {}
  end

  def user_token_header(user, token_payload)
    {
      'HTTP_AUTHORIZATION' => "Bearer #{user_token(user, token_payload)}"
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end

  def user_token(user, token_payload)
    jwt_payload =
      {
        'sub' => user.sub,
        'iss' => jwk[:issuer],
        'aud' => 'P4L-API'
      }.merge(token_payload)
    JWT.encode(jwt_payload, jwk.signing_key, 'RS256', kid: jwk[:kid])
  end

  def jwk
    @@jwk ||= begin
      jwk_descriptive_params = {
        kid: 'my-kid',
        se: 'sig',
        alg: 'RS256',
        issuer: 'cognito-idp.us-east-1.amazonaws.com',
        private: true
      }
      jwk = JWT::JWK.new(@@rsa_key, jwk_descriptive_params)
      MockJWKClient.add_key(jwk.export(include_private: true))
      jwk
    end
  end

  class MockJWKClient
    # this isn't really a Set, it's just an Array.
    @@jwks ||= JWT::JWK::Set.new

    def self.call(_options)
      @@jwks
    end

    def self.add_key(key)
      @@jwks << key
    end
  end
end
