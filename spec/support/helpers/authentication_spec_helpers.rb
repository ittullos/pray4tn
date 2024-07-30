# frozen_string_literal: true

module AuthenticationSpecHelpers
  def authenticated_user(user)
    # authenticate a user
    # create one if you need to
    # return the user
  end

  def is_authenticated?(user)
    # tell me if this user has been authenticated
  end

  def unauthorized_response
    { 'data' => '', 'errors' => 'Unauthorized' }
  end
end
