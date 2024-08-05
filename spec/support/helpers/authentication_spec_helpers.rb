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
      'HTTP_AUTHORIZATION' => user_token(user)
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end

  def user_token(user)
    # user factory needs a sub now, but you knew that
    # create a key
    # create a JWK from a key and export it, then save it to the mock client
    # MockJWKClient.add_key(exported_key)
    JWT.encode(user.sub, 'some_jwt_secret', 'RS256') # use the key here
    # like so:
    # foobar = OpenSSL::PKey::RSA.generate 1024
    # JWT.encode(user.sub, foobar, 'RS256')
    #
    # 'https://github.com/jwt/ruby-jwt/blob/main/README.md#json-web-key-jwk
    # optional_parameters = { kid: 'my-kid', use: 'sig', alg: 'RS512' } # need to use private: true to use signing_key as below
    # jwk = JWT::JWK.new(OpenSSL::PKey::RSA.new(2048), optional_parameters)

    # # Encoding
    # payload = { data: 'data' }
    # token = JWT.encode(payload, jwk.signing_key, jwk[:alg], kid: jwk[:kid])

    # # JSON Web Key Set for advertising your signing keys
    # jwks_hash = JWT::JWK::Set.new(jwk).export
    # # Import a JWK Hash (showing an HMAC example)
    # jwk = JWT::JWK.new({ kty: 'oct', k: 'my-secret', kid: 'my-kid' })

    # # Import an OpenSSL key
    # # You can optionally add descriptive parameters to the JWK
    # desc_params = { kid: 'my-kid', use: 'sig' }
    # jwk = JWT::JWK.new(OpenSSL::PKey::RSA.new(2048), desc_params)

    # # Export as JWK Hash (public key only by default)
    # jwk_hash = jwk.export
    # jwk_hash_with_private_key = jwk.export(include_private: true)

    # # Export as OpenSSL key
    # public_key = jwk.verify_key
    # private_key = jwk.signing_key if jwk.private?

    # # You can also import and export entire JSON Web Key Sets
    # jwks_hash = { keys: [{ kty: 'oct', k: 'my-secret', kid: 'my-kid' }] }
    # jwks = JWT::JWK::Set.new(jwks_hash)
    # jwks_hash = jwks.export
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
