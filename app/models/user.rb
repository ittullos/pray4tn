class User < Sequel::Model
  one_to_many :commitments
  one_to_many :checkpoints
end