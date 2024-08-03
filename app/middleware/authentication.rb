# frozen_string_literal: true

module Authentication
  class Cognito
    def initialize(app)
      @app = app
    end

    def call(env)
      # Get the token from the header
      # verify the token
      # grab the user from the decoded token
      #
      # token = extract_token(Rack::Request.new(env))
      # payload = (JsonWebToken.new(token).verify!)
      # user = User.find_by_sub(payload[:sub])

      email = Rack::Request.new(env).fetch_header('HTTP_P4L_EMAIL') { nil }
      user = User.find_by_email(email)

      if user
        env[:user] = user
        @app.call(env)
      else
        Rack::Response.new({ data: '', errors: 'Unauthorized' }.to_json, 401, {}).finish
      end
    end

    private

    def extract_token(request)
    end
  end
end
