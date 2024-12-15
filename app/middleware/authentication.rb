# frozen_string_literal: true

module Authentication
  class Cognito
    def initialize(app)
      @app = app
    end

    def call(env)
      token = extract_token(env)
      return unauthorized_response unless token

      decoded_token = JsonWebToken.new(token).verify!
      user = User.find_or_create_by(sub: decoded_token.fetch('sub'))

      if user
        env[:user] = user
        @app.call(env)
      else
        unauthorized_response
      end
    rescue KeyError, JWT::DecodeError
      unauthorized_response
    end

    private

    def unauthorized_response
      Rack::Response.new({ data: '', errors: 'Unauthorized' }.to_json, 401, {}).finish
    end

    def extract_token(env)
      scheme, token = Rack::Request.new(env).fetch_header('HTTP_AUTHORIZATION')&.split
      return nil unless scheme&.downcase == 'bearer'

      token
    end
  end
end
