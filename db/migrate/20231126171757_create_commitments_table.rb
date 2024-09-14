class CreateCommitmentsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :commitments do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
