require 'aws-record'

class DevotionalNoIdError < StandardError; end
class Devotional
  include Aws::Record
  set_table_name ENV['DEVOTIONAL_TABLE_NAME']

  integer_attr  :id,   hash_key: true
  string_attr   :title
  string_attr   :url
  string_attr   :img_url

  def self.new_devotional(data)
    verse = new(data)
    verse.save!
    verse
  end
end