# require 'aws-record'

class Verse
  # include Aws::Record
  # set_table_name ENV['VERSE_TABLE_NAME']

  # integer_attr :day,      hash_key:  true
  # string_attr  :version,  range_key: true
  # string_attr  :notation
  # string_attr  :scripture

  def self.new_verse(data)
    verse = new(data)
    verse.save!
    verse
  end
end
