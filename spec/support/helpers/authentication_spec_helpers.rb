# frozen_string_literal: true

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
      'HTTP_P4L_EMAIL' => user.email
    }
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end
end
