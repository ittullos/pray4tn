require 'aws-record'

Aws.config.update(
  endpoint: 'http://localhost:8000'
)

def migrate_model(model)
  cfg = Aws::Record::TableConfig.define do |t|
    t.model_class(model)
    t.read_capacity_units(5)
    t.write_capacity_units(2)
  end
  cfg.migrate!
  puts "#{model} table migrated!!!"
end

def delete_table(model)
  begin
    model.dynamodb_client.delete_table table_name: model.table_name
  rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
    puts "We tried to delete a table that doesnt exist: #{model.table_name}"
  end
end


def clean_table(model)
  puts "cleaning #{model} table!!!"
  model.scan.each {|t| t.delete!} if model.table_exists?
  migrate_model(model)
end

