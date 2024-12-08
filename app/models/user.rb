# frozen_string_literal: true

class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :sub
  validates_uniqueness_of :email
  validates_uniqueness_of :sub

  has_many :residents, -> { order(position: :asc) }
  has_many :routes
  has_many :commitments, -> { order(created_at: :desc) }

  def current_commitment
    commitments.first
  end
end
