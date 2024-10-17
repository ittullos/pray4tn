class AddSubToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sub, :string, null: false
    add_index :users, :sub, unique: true
  end
end
