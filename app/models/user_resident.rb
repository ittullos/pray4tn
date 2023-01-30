require 'aws-record'

class UserResident
  include Aws::Record
  set_table_name ENV['USER_RESIDENT_TABLE_NAME']

  integer_attr :user_id,   hash_key:   true
  string_attr  :match_key, range_key:  true
  string_attr  :geohash
  string_attr  :latitude
  string_attr  :longitude
  string_attr  :name
  string_attr  :address
  string_attr  :loaded_at

  def self.all(user_id)
    UserResident.query(
      key_condition_expression: "user_id = :id",
      expression_attribute_values: { ":id" => user_id })
  end

  def self.next_name(user_id)
    item = all(user_id).first
    if item.nil? 
      ""
    else
      item.name
    end
  end

  def last_name(user_id)
    Checkpoint.last_name(user_id)
  end
    


  # dataset_module do
  #   def active
  #     where(:status => "active")
  #   end

  #   def next_up
  #     order_by(Sequel.desc(:id)).first
  #   end
  # end
end
