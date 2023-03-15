require "dotenv"
require 'aws-record'
Dotenv.load


SOURCE      = ENV["ROUTE_TABLE_NAME_2"]
DESTINATION = ENV["ROUTE_TABLE_NAME"]

puts "This will overwrite the contents of table: #{DESTINATION}"
puts "Are you sure you want to do this? (y/n): "
input = gets.chomp

if input == "y" || input == "Y"

  class Source
    include Aws::Record
    set_table_name SOURCE

    integer_attr  :id,         hash_key: true
    integer_attr  :started_at
    integer_attr  :stopped_at
    integer_attr  :mileage
    integer_attr  :prayer_count
    integer_attr  :seconds
  end

  class TargetDdb
    include Aws::Record
    set_table_name DESTINATION

    integer_attr  :id,         hash_key: true
    integer_attr  :started_at
    integer_attr  :stopped_at
    integer_attr  :mileage
    integer_attr  :prayer_count
    integer_attr  :seconds
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