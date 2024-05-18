
class Verse < ActiveRecord::Base
  validates_presence_of :day, :scripture, :notation, :version
  validates_uniqueness_of :day
end
