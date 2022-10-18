# require "./config/environment"

class User < Sequel::Model
  one_to_many :commitments
end