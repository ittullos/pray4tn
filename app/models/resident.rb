# frozen_string_literal: true

require 'acts_as_list'

class Resident < ActiveRecord::Base
  belongs_to :resident_list
  has_one :user, through: :resident_list

  validates_uniqueness_of :name, case_sensitive: false

  acts_as_list scope: :resident_list

  def next_resident
    lower_item
  end
end
