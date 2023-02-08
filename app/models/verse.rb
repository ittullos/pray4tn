require 'aws-record'

class Verse
  include Aws::Record
  set_table_name ENV["VERSE_TABLE_NAME"]

  string_attr :version,   hash_key:  true
  string_attr :notation,  range_key: true
  string_attr :scripture

  def self.new_verse(data)
    verse = new(data)
    verse.save!
    verse
  end
end