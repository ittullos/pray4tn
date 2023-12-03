class Route < ActiveRecord::Base
  belongs_to :user
  belongs_to :commitment, optional: true

end
