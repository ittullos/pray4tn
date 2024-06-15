# frozen_string_literal: true

class Resident < ActiveRecord::Base
  belongs_to :resident_list
  has_one :user, through: :resident_list

  validates_uniqueness_of :name, case_sensitive: false
end
