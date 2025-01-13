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

ActiveRecord::Schema[8.0].define(version: 2025_01_13_103357) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "property_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "guest_count"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_method_id"
    t.decimal "total_price"
    t.integer "customer_id", null: false
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["property_id"], name: "index_bookings_on_property_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.integer "property_id", null: false
    t.date "date"
    t.string "status"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "property_id"], name: "index_calendars_on_date_and_property_id", unique: true
    t.index ["property_id"], name: "index_calendars_on_property_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "zip_code"
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "description"
    t.integer "max_guests"
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "country"
    t.string "contact_email"
    t.integer "min_days_stay", default: 1, null: false
    t.integer "max_days_stay", default: 30, null: false
    t.decimal "weekly_discount", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "monthly_discount", precision: 5, scale: 2, default: "0.0", null: false
    t.index ["admin_id"], name: "index_properties_on_admin_id"
  end

  create_table "reservation_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "customers"
  add_foreign_key "bookings", "properties"
  add_foreign_key "calendars", "properties"
  add_foreign_key "properties", "admins"
end
