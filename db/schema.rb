# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_15_035856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupon_setting_duration_options", force: :cascade do |t|
    t.bigint "coupon_setting_id"
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_setting_id"], name: "index_coupon_setting_duration_options_on_coupon_setting_id"
  end

  create_table "coupon_setting_follow_options", force: :cascade do |t|
    t.bigint "coupon_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_setting_id"], name: "index_coupon_setting_follow_options_on_coupon_setting_id"
  end

  create_table "coupon_settings", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "status", null: false
    t.string "name", null: false
    t.string "message", null: false
    t.binary "thumbnail", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "line_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "url", null: false
    t.string "status", null: false
    t.datetime "issued_at", null: false
    t.datetime "exchanged_at"
    t.datetime "disabled_at"
    t.bigint "line_user_id"
    t.bigint "coupon_setting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_setting_id"], name: "index_tickets_on_coupon_setting_id"
    t.index ["line_user_id"], name: "index_tickets_on_line_user_id"
  end

  add_foreign_key "coupon_setting_duration_options", "coupon_settings"
  add_foreign_key "coupon_setting_follow_options", "coupon_settings"
  add_foreign_key "tickets", "coupon_settings"
  add_foreign_key "tickets", "line_users"
end
