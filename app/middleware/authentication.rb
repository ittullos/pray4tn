# frozen_string_literal: true

module Authentication
  class Cognito
    def initialize(app)
      @app = app
    end

    def call(env)
      access_token = extract_access_token(env)
      return unauthorized_response unless access_token

      decoded_access_token = JsonWebToken.new(access_token).verify!
      id_token = extract_id_token(env)
      return unauthorized_response unless id_token

      decoded_id_token = JsonWebToken.new(id_token).verify!
      email = decoded_id_token.fetch('email')

      user = User.find_or_create_by!(sub: decoded_access_token.fetch('sub')) do |u|
        u.email = email
      end

      if user.present?
        update_user_email_if_needed(user, email)
        env[:user] = user
        @app.call(env)
      else
        unauthorized_response
      end
    rescue KeyError, JWT::DecodeError
      unauthorized_response
    end

    private

    def update_user_email_if_needed(user, email)
      user.email = email
      user.save! if user.changed?
    end

    def unauthorized_response
      Rack::Response.new({ data: '', errors: 'Unauthorized' }.to_json, 401, {}).finish
    end

    def extract_access_token(env)
      scheme, access_token = Rack::Request.new(env).fetch_header('HTTP_AUTHORIZATION')&.split
      return nil unless scheme&.downcase == 'bearer'

      access_token
    end

    def extract_id_token(env)
      scheme, id_token = Rack::Request.new(env).get_header('HTTP_X_ID_TOKEN')&.split
      return nil unless scheme&.downcase == 'bearer'

      id_token
    end
  end
end
