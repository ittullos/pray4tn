require 'yaml'

class SeedDevotionals
  def self.run
    devotionals = YAML.load_file('db/seeds/devotionals.yml')
    devotionals.each do |devotional|
      Devotional.find_or_create_by(devotional).save!
    end
    puts Devotional.count
    puts "Inserted #{devotionals.count} devotionals"
  end
end
