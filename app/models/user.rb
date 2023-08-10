require 'aws-record'

class UserNoIdError < StandardError; end
class User
  include Aws::Record
  set_table_name ENV['USER_TABLE_NAME']

  string_attr  :email,     hash_key: true
  string_attr  :password
  integer_attr :commitment_id
  integer_attr :achievement

  def reset_password(password)
    self.password = password
    save
  end

  def self.new_user(data)
    data[:achievement] = 0 
    user = new(data)
    user.save!
    user
  end


  def get_stats
    commit_mileage = 0
    commit_seconds = 0
    commit_prayers = 0
    all_time_miles = 0
    all_time_duration = 0
    all_time_prayers = 0
    # pry.byebug
    if commitment_id && commitment_id != 0
      commit = Commitment.find(commitment_id: commitment_id)
      journey = Journey.find(title: commit.journey_id)
      title = journey.title
      target_date = commit.target_date
      target_miles = journey.annual_miles
    end

    Route.scan.each do |route|
      if route.commitment_id == commitment_id
        commit_mileage += route.mileage || 0
        commit_seconds += route.seconds || 0
        commit_prayers += route.prayer_count || 0
      end
    end
    
    user_checkpoints = Checkpoint.user_checkpoints(email).to_a
    user_checkpoints.each do |point|
      all_time_miles += point.distance(Checkpoint.previous_checkpoint(point).to_a.last)

      if point.type != "start"
        all_time_duration += point.recorded_at - Checkpoint.previous_checkpoint(point).to_a.last.recorded_at
        if point.type == "prayer"
          all_time_prayers += 1
        end
      end
    end

    achievement_array = []
    next_journey_array = []
    commit_achievement = "No journey achieved yet. Keep at it!!"
    top_journey = 0

    Journey.scan.each do |journey|
      
      if achievement >= journey.annual_miles
        achievement_array.push([journey.title, journey.annual_miles])
      else
        next_journey_array.push([journey.title, journey.annual_miles])
      end
      if commit_mileage >= journey.annual_miles && journey.annual_miles > top_journey
        top_journey = journey.annual_miles if journey.annual_miles > top_journey
        # pry.byebug
        if journey.title.include? 'I-' 
          commit_achievement = "So far you have traveled the distance of the #{journey.title} (#{journey.annual_miles/1000} miles)"
        elsif journey.title.include? 'tate'
          commit_achievement = "So far you have traveled the distance of the #{journey.title} (#{journey.annual_miles/1000} miles)"
        else
          commit_achievement = "So far you have traveled the distance of #{journey.title} (#{journey.annual_miles/1000} miles)"
        end
      end
    end
    # pry.byebug
    achievement_array.sort_by! { |x,y| y }
    next_journey_array.sort_by! { |x,y| y}
    
    {
      title:          title || "",
      target_miles:   target_miles || "",
      progress_miles: commit_mileage,
      prayers:        commit_prayers,
      seconds:        commit_seconds,
      target_date:    target_date || "",
      all_time_miles: all_time_miles,
      all_time_duration: all_time_duration,
      all_time_prayers: all_time_prayers,
      achievement: achievement_array || "",
      commit_achievement: commit_achievement,
      next_journey: next_journey_array[0][0] || "",
      next_journey_miles: next_journey_array[0][1] || 0
    }
  end
end