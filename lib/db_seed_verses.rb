require 'yaml'

class SeedVerses
  def self.run
    verses = YAML.load_file('db/seeds/verses.yml')
    verses.each do |verse|
      Verse.find_or_create_by!(verse)
    end
    puts Verse.count
    puts "Inserted #{verses.count} verses"
  end
end
