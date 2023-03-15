require "dotenv"
require 'aws-record'
Dotenv.load


SOURCE      = ENV["USER_TABLE_NAME"]
DESTINATION = ENV["USER_TABLE_NAME_2"]

puts "This will overwrite the contents of table: #{DESTINATION}"
puts "Are you sure you want to do this? (y/n): "
input = gets.chomp

if input == "y" || input == "Y"

  class Source
    include Aws::Record
    set_table_name SOURCE

    string_attr :email, hash_key: true
    string_attr :password
  end

  class TargetDdb
    include Aws::Record
    set_table_name DESTINATION

    string_attr :email, hash_key: true
    string_attr :password
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