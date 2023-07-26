require 'aws-record'

class JourneyNoIdError < StandardError; end
class Journey
  include Aws::Record
  set_table_name ENV["JOURNEY_TABLE_NAME"]

  string_attr  :title,       hash_key: true       
  integer_attr :annual_miles
  integer_attr :monthly_miles
  integer_attr :weekly_miles

  def self.new_journey(data)
    journey = new(data)
    journey.save!
    journey
  end
end