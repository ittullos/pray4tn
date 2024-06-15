# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_15_155133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commitments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_commitments_on_user_id"
  end

  create_table "prayers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resident_id", null: false
    t.bigint "route_id"
    t.datetime "recorded_at", null: false
    t.index ["resident_id"], name: "index_prayers_on_resident_id"
    t.index ["route_id"], name: "index_prayers_on_route_id"
    t.index ["user_id"], name: "index_prayers_on_user_id"
  end

  create_table "resident_lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "loaded_at", null: false
    t.index ["user_id"], name: "index_resident_lists_on_user_id"
  end

  create_table "residents", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "loaded_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "resident_list_id"
    t.index ["name"], name: "index_residents_on_name", unique: true
    t.index ["resident_list_id"], name: "index_residents_on_resident_list_id"
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "commitment_id"
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.integer "step_count", default: 0, null: false
    t.integer "seconds", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_routes_on_commitment_id"
    t.index ["user_id"], name: "index_routes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "verses", force: :cascade do |t|
    t.integer "day", null: false
    t.text "scripture", null: false
    t.string "notation", null: false
    t.string "version", null: false
    t.index ["day"], name: "index_verses_on_day", unique: true
  end

  add_foreign_key "commitments", "users"
  add_foreign_key "prayers", "residents"
  add_foreign_key "prayers", "routes"
  add_foreign_key "prayers", "users"
  add_foreign_key "resident_lists", "users"
  add_foreign_key "routes", "commitments"
  add_foreign_key "routes", "users"
end
