class Route < Sequel::Model
  one_to_many :checkpoints
end