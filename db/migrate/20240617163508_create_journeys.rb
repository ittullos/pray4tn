class CreateJourneys < ActiveRecord::Migration[7.1]
  def change
    create_table :journeys do |t|
      t.integer :annual_miles, null: false
      t.integer :monthly_miles, null: false
      t.integer :weekly_miles, null: false
      t.string :title, null: false, index: { unique: true }
    end
  end
end
