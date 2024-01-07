# require 'aws-record'

class UserResident
  # include Aws::Record
  # set_table_name ENV['USER_RESIDENT_TABLE_NAME']

  # string_attr  :user_id,   hash_key:   true
  # string_attr  :match_key, range_key:  true
  # string_attr  :geohash
  # string_attr  :latitude
  # string_attr  :longitude
  # string_attr  :name
  # string_attr  :address
  # string_attr  :loaded_at

  def self.all(user_id)
    UserResident.query(
      key_condition_expression: "user_id = :id",
      expression_attribute_values: { ":id" => user_id })
  end

  def self.next_resident(user_id)
    find_next(all(user_id).to_a, last_prayer_match_key(user_id))
  end

  def self.last_prayer_match_key(user_id)
    match_key = Checkpoint.last_prayer(user_id)
  end

  def self.find_next(residents, match_key)
    resident_count = residents.count
    return nil if resident_count == 0

    if match_key
      index = residents.index {|r| r.match_key == match_key}
    end

    if index.nil?
      index = 0
    else
      index += 1
      index = index - resident_count if index == resident_count
    end

    residents[index]
  end
end
