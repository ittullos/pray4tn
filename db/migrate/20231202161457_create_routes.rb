class CreateRoutes < ActiveRecord::Migration[7.1]
  def change
    create_table :routes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :commitment, null: true, foreign_key: true

      t.datetime :started_at, null: true
      t.datetime :stopped_at, null: true

      t.integer :step_count, null: false, default: 0
      t.integer :seconds, null: false, default: 0

      t.timestamps
    end
  end
end
