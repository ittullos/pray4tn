class AddUniqueIndexToVerses < ActiveRecord::Migration[7.1]
  def change
    # Remove the old unique index on day if it exists
    remove_index :verses, :day if index_exists?(:verses, :day)

    # Add a new unique index on the combination of day and version
    add_index :verses, [:day, :version], unique: true
  end
end
