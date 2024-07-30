require 'yaml'

class SeedUsers
  def self.run
    users = YAML.load_file('db/seeds/users.yml')
    users.each do |user|
      User.create(user)
    end
  end
end
