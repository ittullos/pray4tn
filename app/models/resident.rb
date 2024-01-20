# frozen_string_literal: true

class Resident < ActiveRecord::Base
  validates_uniqueness_of :name, case_sensitive: false
end
