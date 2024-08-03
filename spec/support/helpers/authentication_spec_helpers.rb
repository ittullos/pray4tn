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
      'HTTP_P4L_EMAIL' => user.email # becomes user_token
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end

  def user_token(user)
    # user factory needs a sub now, but you knew that
    JWT.encode(user.sub, 'some_jwt_secret', 'HS256')
  end
end
