class UpdateResidentsUniqueIndex < ActiveRecord::Migration[7.1]
  def change
    # Remove the existing unique index on the name column
    remove_index :residents, name: "index_residents_on_name"

    # Add a new unique index scoped to user_id
    add_index :residents, [:name, :user_id], unique: true
  end
end
