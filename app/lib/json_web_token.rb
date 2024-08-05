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
      nil, # we don't know the key, but we will know it in test, right?
      true, # verify the signature
      {
        algorithm: 'RS256', # make sure the spec helper matches this too
        iss: domain_url, # should point to the domain of Cognito or whatever
        verify_iss: true,
        aud: 'P4L-API', # P4l-api or something
        verify_aud: true,
        jwks: { keys: JsonWebToken.jwks[:keys] } # maybe this is a lambda?
      }
    )
    @payload
  end

  def domain_url
    'cognito-idp.us-east-1.amazonaws.com'
  end

  # This should be a separate singleton client that will cache the keys for us.
  # https://cognito-idp.us-east-1.amazonaws.com/us-east-1_CbBDA8Y5m/.well-known/jwks.json
  def jwks
    # @jwks ||= JWKClient.call?

  end
end
