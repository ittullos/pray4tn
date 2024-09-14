class CreateVerses < ActiveRecord::Migration[7.1]
  def change
    create_table :verses do |t|
      t.integer :day, null: false, index: { unique: true }
      t.text :scripture, null: false
      t.string :notation, null: false
      t.string :version, null: false
    end
  end
end
