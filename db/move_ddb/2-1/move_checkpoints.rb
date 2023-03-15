require "dotenv"
require 'aws-record'
Dotenv.load


SOURCE      = ENV["CHECKPOINT_TABLE_NAME_2"]
DESTINATION = ENV["CHECKPOINT_TABLE_NAME"]

puts "This will overwrite the contents of table: #{DESTINATION}"
puts "Are you sure you want to do this? (y/n): "
input = gets.chomp

if input == "y" || input == "Y"

  class Source
    include Aws::Record
    set_table_name SOURCE

    string_attr  :user_id,   hash_key: true
    integer_attr :recorded_at, range_key: true
    integer_attr :route_id
    string_attr  :lat
    string_attr  :long
    string_attr  :type
    string_attr  :match_key
  end

  class TargetDdb
    include Aws::Record
    set_table_name DESTINATION

    string_attr  :user_id,   hash_key: true
    integer_attr :recorded_at, range_key: true
    integer_attr :route_id
    string_attr  :lat
    string_attr  :long
    string_attr  :type
    string_attr  :match_key
  end

  begin
    scan = Source.scan
    scan.each do |r|
      p "Scanned: #{r.to_h}"
      mdlog = TargetDdb.new(r.to_h)
      mdlog.save!
    end
  rescue  Aws::DynamoDB::Errors::ServiceError => error
    puts 'Unable to add log record:'
    puts error.message
  end
end