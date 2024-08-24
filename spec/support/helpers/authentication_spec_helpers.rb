# frozen_string_literal: true

require 'jwt'

module AuthenticationSpecHelpers
  def authenticated(user = FactoryBot.create(:user))
    headers.merge!(user_token_header(user))
    user
  end

  def headers
    @headers ||= {}
  end

  def user_token_header(user)
    {
      'HTTP_P4L_EMAIL' => user.email, # becomes user_token
      'HTTP_AUTHORIZATION' => "Bearer #{user_token(user)}"
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end

  def user_token(user)
    # DOES THIS NEED TO BE PRIVATE??? or is it private by default?
    # this should be memoized so we don't generate a brand new one for every spec
    rsa_key = OpenSSL::PKey::RSA.generate 1024

    jwk_descriptive_params = {
      kid: 'my-kid',
      se: 'sig',
      alg: 'RS256',
      issuer: 'cognito-idp.us-east-1.amazonaws.com',
      # private: true # do I need this or not?
    }
    jwk = JWT::JWK.new(rsa_key, jwk_descriptive_params)

    MockJWKClient.add_key(jwk.export(include_private: true))

    jwt_payload =
      {
        'data' => { 'sub' => user.sub },
        'iss' => jwk[:issuer],
        'aud' => 'P4L-API'
      }
    JWT.encode(jwt_payload, jwk.signing_key, 'RS256')
  end

  class MockJWKClient # subclass the real one
    # this isn't really a Set, it's just an Array.
    @@jwks = JWT::JWK::Set.new # this can go if we subclass

    def self.call # this can go if we subclass
      self.fetch_keys
    end

    def self.fetch_keys
      @@jwks
    end

    def self.add_key(key)
      @@jwks << key
    end

    # def jwks
    #   {
    #     keys: [{
    #       :alg=>"RS256",
    #       :kty=>"RSA",
    #       :use=>"sig",
    #       :n=>"...",
    #       :e=>"...",
    #       :kid=>"...",
    #       :x5t=>"...",
    #       :x5c=>["..."]
    #     }]
    #   }
    # end
  end
end
