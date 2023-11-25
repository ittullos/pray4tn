# frozen_string_literal: true

class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
end

# class User
# def self.new_user(data)
#   user = new(data)
#   user.save!
#   user
# end

# def get_stats
#   commit_mileage = 0
#   commit_seconds = 0
#   commit_prayers = 0
#   commit = Commitment.find(commitment_id: commitment_id)
#   journey = Journey.find(title: commit.journey_id)
#   title = journey.title
#   target_date = commit.target_date
#   commit_date = commit.commit_date
#   target_miles = journey.target_miles

#   Route.scan.each do |route|
#     if route.commitment_id == commitment_id
#       commit_mileage += route.mileage
#       commit_seconds += route.seconds
#       commit_prayers += route.prayer_count
#     end
#   end
#   {
#     title:          title,
#     target_miles:   target_miles,
#     progress_miles: commit_mileage,
#     prayers:        commit_prayers,
#     seconds:        commit_seconds,
#     target_date:    target_date,
#     commit_date:    commit_date
#   }
# end
# end
