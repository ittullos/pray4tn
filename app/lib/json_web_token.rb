# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  attr_reader :payload, :headers

  def initialize(token)
    @token = token
  end

  def verify!
    @payload, @headers = JWT.decode(
      @token,
      nil,
      true, # verify the signature
      {
        algorithm: 'RS256',
        iss: domain_url,
        verify_iss: true,
        jwks: jwk_loader
      }
    )
    @payload
  end

  def domain_url
    ENV['COGNITO_DOMAIN_URL'] || 'cognito-idp.us-east-1.amazonaws.com'
  end

  def jwk_loader
    JWKClient.instance
  end
end
