# frozen_string_literal: true

module Authentication
  class Cognito
    def initialize(app)
      @app = app
    end

    def call(env)
      email = Rack::Request.new(env).fetch_header('HTTP_P4L_EMAIL') { nil }
      user = User.find_by_email(email)

      if user
        env[:user] = user
        @app.call(env)
      else
        Rack::Response.new({ data: '', errors: 'Unauthorized' }.to_json, 401, {}).finish
      end
    end
  end
end
