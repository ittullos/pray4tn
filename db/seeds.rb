require 'active_record'
require 'roo'
require_relative '../app/models/verse'

# Load 100 verses from an .xlsx document into the Verses table
xlsx_path = 'db/seed_data/100_verses.xlsx'
xlsx = Roo::Spreadsheet.open(xlsx_path)
sheet = xlsx.sheet(0)

(2..101).each do |i|
  notation = sheet.cell(i, 1)
  verse_text = sheet.cell(i, 2)
  Verse.create(scripture: verse_text, notation: notation, version: 'CSB', day: i - 1)
end

User.create(email: "isaac.tullos@gmail.com", first_name: "Isaac", last_name: "Tullos")

puts 'Database has been seeded with initial data.'
