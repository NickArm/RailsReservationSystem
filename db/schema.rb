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

ActiveRecord::Schema[8.0].define(version: 2025_02_05_194332) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.string "unique_code", null: false
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["property_id"], name: "index_bookings_on_property_id"
    t.index ["unique_code"], name: "index_bookings_on_unique_code", unique: true
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
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "enabled_payment_methods", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.integer "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_enabled_payment_methods_on_admin_id"
    t.index ["payment_method_id"], name: "index_enabled_payment_methods_on_payment_method_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.integer "customer_id", null: false
    t.string "invoice_number"
    t.decimal "total_amount"
    t.decimal "tax_amount"
    t.integer "payment_status"
    t.datetime "issued_date"
    t.datetime "due_date"
    t.datetime "paid_date"
    t.text "notes"
    t.string "vat_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_invoices_on_booking_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
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

  create_table "settings", force: :cascade do |t|
    t.string "company_name"
    t.string "registration_number"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "logo"
    t.string "language"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_postcode"
    t.string "company_email"
    t.string "notifications_email"
    t.string "smtp_address"
    t.integer "smtp_port"
    t.string "smtp_domain"
    t.string "smtp_user_name"
    t.string "smtp_password"
    t.string "smtp_authentication"
    t.boolean "smtp_enable_starttls"
    t.boolean "ssl", default: false, null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.decimal "rate", precision: 8, scale: 2
    t.integer "rate_type", default: 0, null: false
    t.integer "application_case", default: 0, null: false
    t.integer "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_taxes_on_property_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "customers"
  add_foreign_key "bookings", "properties"
  add_foreign_key "calendars", "properties"
  add_foreign_key "enabled_payment_methods", "admins"
  add_foreign_key "enabled_payment_methods", "payment_methods"
  add_foreign_key "invoices", "bookings"
  add_foreign_key "invoices", "customers"
  add_foreign_key "properties", "admins"
  add_foreign_key "taxes", "properties"
end
