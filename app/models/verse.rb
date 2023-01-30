require 'aws-record'

class Verse
  include Aws::Record
  set_table_name ENV["VERSE_TABLE_NAME"]

  string_attr :version,   hash_key:  true
  string_attr :notation,  range_key: true
  string_attr :scripture

end