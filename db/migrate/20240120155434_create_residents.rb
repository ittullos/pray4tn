class CreateResidents < ActiveRecord::Migration[7.1]
  def change
    create_table :residents do |t|
      t.string :name, null: false, index: { unique: true }
      t.datetime :loaded_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
