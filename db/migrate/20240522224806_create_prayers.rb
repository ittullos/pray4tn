class CreatePrayers < ActiveRecord::Migration[7.1]
  def change
    create_table :prayers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :resident, null: false, foreign_key: true
      t.references :route, null: true, foreign_key: true

      t.datetime :recorded_at, null: false
    end
  end
end
