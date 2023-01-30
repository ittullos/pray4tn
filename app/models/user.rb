require 'aws-record'

class UserNoIdError < StandardError; end
class User
  include Aws::Record
  set_table_name ENV['USER_TABLE_NAME']

  string_attr  :email, hash_key: true
  string_attr  :password
  integer_attr :id 

  def reset_password(password)
    self.password = password
    save
  end

  def self.new_user(data)
    user = new(data)
    user.save!
    user
  end

  def self.next_user_id
    last_user = self.scan.to_a.last
    return last_user.id + 1 if last_user
    return 1
  end

  def save!
    save
  end

  def save
    unless persisted?
      self.id = User.next_user_id
    end
    if self.id.nil? 
      raise UserNoIdError, "Tried to save user with no ID"
    end   
    super
  end
end