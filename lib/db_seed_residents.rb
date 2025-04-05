require 'yaml'

class SeedResidents
  def self.run
    residents = YAML.load_file('db/seeds/residents.yml')
    residents.each do |resident|
      Resident.find_or_create_by(resident).save!
    end
    puts Resident.count
    puts "Inserted #{residents.count} residents"
  end
end
