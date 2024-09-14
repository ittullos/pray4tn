class CreateDevotionals < ActiveRecord::Migration[7.1]
  def change
    create_table :devotionals do |t|
      t.string :title, null: false, index: { unique: true }
      t.string :url, null: false
      t.string :img_url, null: false
    end
  end
end
