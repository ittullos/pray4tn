# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  attr_reader :payload, :headers

  def initialize(token)
    @token = token
  end

  def verify!
    # Take your token and verify it with the JWKs
    # expose payload and stuff so we can use it later
    @payload, @headers = JWT.decode(
      @token,
      nil,
      true, # verify the signature
      {
        algorithm: 'RS256',
        iss: domain_url,
        verify_iss: true,
        aud: 'P4L-API',
        verify_aud: true,
        jwks: jwk_loader
      }
    )
    @payload
  end

  def domain_url
    'cognito-idp.us-east-1.amazonaws.com'
  end

  # This should be a separate singleton client that will cache the keys for us.
  # https://cognito-idp.us-east-1.amazonaws.com/us-east-1_CbBDA8Y5m/.well-known/jwks.json
  def jwk_loader
    AuthenticationSpecHelpers::MockJWKClient
  end
end
