require 'yaml'

class SeedUsers
  def self.run
    users = YAML.load_file('db/seeds/users.yml')
    users.each do |user|
      User.find_or_create_by(user)
    end
    puts "Inserted #{users.count} users"
  end
end
