# require 'aws-record'

# class JourneyNoIdError < StandardError; end
# class Journey < Sequel::Model
  # def initialize(attrs)
  #   super(attrs)
  # end
  # include Aws::Record
  # set_table_name ENV["JOURNEY_TABLE_NAME"]

  # string_attr  :title,       hash_key: true
  # integer_attr :target_miles
  # string_attr  :graphic_url

  # def self.new_journey(*data)
  #   binding.pry
  #   journey = new(*data)
  #   journey.save!
  #   journey
  # end
# end
