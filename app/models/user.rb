class User < Sequel::Model
  one_to_many :commitments
  one_to_many :checkpoints
  one_to_many :user_residents
end