# frozen_string_literal: true

require 'acts_as_list'

class Resident < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :name, case_sensitive: false, scope: :user_id

  acts_as_list scope: :user

  def next_resident
    lower_item || user.residents.limit(1).first
  end
end
