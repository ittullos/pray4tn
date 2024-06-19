# frozen_string_literal: true

class Resident < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :name, case_sensitive: false
end
