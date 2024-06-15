class ResidentList < ActiveRecord::Base
  belongs_to :user
  has_many :residents

  validates :loaded_at, presence: true
end
