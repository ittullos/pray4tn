require 'yaml'

class SeedJourneys
  def self.run
    journeys = YAML.load_file('db/seeds/journeys.yml')
    journeys.each do |journey|
      Journey.find_or_create_by(journey).save!
    end
    puts Journey.count
    puts "Inserted #{journeys.count} devotionals"
  end
end
