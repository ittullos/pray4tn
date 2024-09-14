class AddPositionAndUserIdToResidentss < ActiveRecord::Migration[7.1]
  def change
    add_column :residents, :position, :integer
    add_reference :residents, :user, index: true, null: true
    add_index :residents, [:user_id, :position], unique: true
  end
end
