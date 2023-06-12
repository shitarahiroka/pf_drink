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

ActiveRecord::Schema[7.0].define(version: 2023_06_12_134412) do
  create_table "drink_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "morning_suggestion"
    t.bigint "afternoon_suggestion"
    t.bigint "evening_suggestion"
    t.float "caffeine_total"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["afternoon_suggestion"], name: "fk_rails_a4c8c7bea6"
    t.index ["evening_suggestion"], name: "fk_rails_da7129ae13"
    t.index ["morning_suggestion"], name: "fk_rails_fb1a8b16ad"
    t.index ["user_id"], name: "index_drink_records_on_user_id"
  end

  create_table "drinks", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "calories"
    t.float "caffeine"
    t.integer "teanine"
    t.string "mood"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.integer "weight"
    t.integer "age"
    t.integer "gender"
    t.integer "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "drink_records", "drinks", column: "afternoon_suggestion"
  add_foreign_key "drink_records", "drinks", column: "evening_suggestion"
  add_foreign_key "drink_records", "drinks", column: "morning_suggestion"
  add_foreign_key "drink_records", "users"
end
