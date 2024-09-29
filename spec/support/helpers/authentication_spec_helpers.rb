# frozen_string_literal: true

require 'jwt'

module AuthenticationSpecHelpers
  def self.included(test)
    test.before do
      allow(JWKClient).to receive(:instance).and_return(MockJWKClient)
    end
  end

  # DOES THIS NEED TO BE PRIVATE??? or is it private by default?
  @@rsa_key ||= OpenSSL::PKey::RSA.generate 1024

  def authenticated(user = FactoryBot.create(:user), token_payload = {})
    # maybe we create and add the RSA and JWK here, since only authenticated users
    # should have their key in Cognito. A user could have a token from somewhere else.
    headers.merge!(user_token_header(user, token_payload))
    user
  end

  def headers
    @headers ||= {}
  end

  def user_token_header(user, token_payload)
    {
      'HTTP_P4L_EMAIL' => user.email, # becomes user_token
      'HTTP_AUTHORIZATION' => "Bearer #{user_token(user, token_payload)}"
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end

  def user_token(user, token_payload)
    jwt_payload =
      {
        'data' => { 'sub' => user.sub }.merge(token_payload),
        'iss' => jwk[:issuer],
        'aud' => 'P4L-API'
      }
    JWT.encode(jwt_payload, jwk.signing_key, 'RS256', kid: jwk[:kid])
  end

  def jwk
    @@jwk ||= begin
      jwk_descriptive_params = {
        kid: 'my-kid',
        se: 'sig',
        alg: 'RS256',
        issuer: 'cognito-idp.us-east-1.amazonaws.com',
        private: true # do I need this or not?
      }
      jwk = JWT::JWK.new(@@rsa_key, jwk_descriptive_params)
      MockJWKClient.add_key(jwk.export(include_private: true))
      jwk
    end
  end

  class MockJWKClient # subclass the real one
    # this isn't really a Set, it's just an Array.
    @@jwks ||= JWT::JWK::Set.new # this can go if we subclass

    def self.call(_options) # this can go if we subclass
      # lambda do |options|
      #   # options[:invalidate] will be `true` if a matching `kid` was not found
      #   # https://github.com/jwt/ruby-jwt/blob/master/lib/jwt/jwk/key_finder.rb#L31
      #   AuthenticationSpecHelpers::MockJWKClient
      # end
      fetch_keys
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
