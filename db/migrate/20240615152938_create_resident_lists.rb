class CreateResidentLists < ActiveRecord::Migration[7.1]
  def change
    create_table :resident_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :loaded_at, null: false
    end
  end
end
