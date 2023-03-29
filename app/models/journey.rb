require 'aws-record'

class JourneyNoIdError < StandardError; end
class Journey
  include Aws::Record
  set_table_name ENV["JOURNEY_TABLE_NAME"]

  string_attr  :title,       hash_key: true       
  integer_attr :target_miles
  string_attr  :graphic_url

  def self.new_journey(data)
    journey = new(data)
    journey.save!
    journey
  end
end