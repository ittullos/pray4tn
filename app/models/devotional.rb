class Devotional < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :url, presence: true
  validates :img_url, presence: true
end
