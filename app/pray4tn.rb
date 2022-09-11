require_relative 'models/user'
require_relative 'models/commitment'

class Pray4TN < Sinatra::Base

    get '/' do
      "Hello World!"
    end

end