require 'aws-record'

class UserNoIdError < StandardError; end
class User
  include Aws::Record
  set_table_name ENV['USER_TABLE_NAME']

  string_attr  :email,     hash_key: true
  string_attr  :password
  integer_attr :commitment_id

  def reset_password(password)
    self.password = password
    save
  end

  def self.new_user(data)
    user = new(data)
    user.save!
    user
  end
end