require './spec/spec_helper'

describe "Pastor4Life API -" do
  include Rack::Test::Methods
  include ApiSpecHelpers

  let(:app) { Sinatra::Application }
  let(:user) { create(:user) }

  let(:headers) do
    {
      'P4L-email' => user.email
    }
  end
end
