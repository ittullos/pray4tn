# frozen_string_literal: true

class Verse < ActiveRecord::Base
  validates_presence_of :day, :scripture, :notation, :version
  validates_uniqueness_of :day

  def self.verse_of_the_day
    find_by(day: (Date.today.yday % 100) + 1)
  end
end
