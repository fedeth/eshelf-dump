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

ActiveRecord::Schema.define(version: 2020_11_15_225944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.text "full_name"
    t.text "address_line"
    t.text "opt_address_line"
    t.text "phone_number"
    t.text "postcode"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.json "aux"
    t.bigint "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.json "aux"
    t.boolean "approved", default: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "content_id", null: false
    t.index ["content_id"], name: "index_comments_on_content_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "log_events", force: :cascade do |t|
    t.text "session_id"
    t.integer "pid"
    t.string "request_uri"
    t.time "timestamp"
    t.text "level"
    t.integer "user_id"
    t.json "data"
    t.boolean "synced"
    t.text "label"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.integer "week_day"
    t.time "open_time"
    t.time "close_time"
    t.integer "lock_version", default: 0
    t.bigint "shop_id"
    t.index ["shop_id"], name: "index_opening_hours_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", default: "NEW"
    t.bigint "user_id"
    t.json "aux", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "payment_intent_id", null: false
    t.string "payment_unit", default: "cents"
    t.integer "payment_amount"
    t.string "status"
    t.json "aux", default: {}
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["payment_intent_id"], name: "index_payments_on_payment_intent_id", unique: true
  end

  create_table "postcodes", primary_key: "postcode", id: :string, force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.index ["latitude", "longitude"], name: "index_postcodes_on_latitude_and_longitude"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "aux"
    t.integer "category_id"
    t.text "status", default: "active", null: false
    t.integer "price"
    t.integer "lock_version", default: 0
    t.bigint "shop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.tsvector "name_tsv"
    t.tsvector "description_tsv"
    t.bigint "display_priority"
    t.text "brand"
    t.text "keywords"
    t.text "specs", default: "{}"
    t.tsvector "brand_tsv"
    t.tsvector "specs_tsv"
    t.tsvector "keywords_tsv"
    t.text "title"
    t.bigint "priority"
    t.tsvector "title_tsv"
    t.bigint "quantity", default: 1
    t.index ["brand"], name: "index_products_on_brand", opclass: :gin_trgm_ops, using: :gin
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["description"], name: "index_products_on_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["display_priority"], name: "index_products_on_display_priority"
    t.index ["keywords"], name: "index_products_on_keywords", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["priority"], name: "index_products_on_priority"
    t.index ["shop_id"], name: "index_products_on_shop_id"
    t.index ["specs"], name: "index_products_on_specs", opclass: :gin_trgm_ops, using: :gin
    t.index ["status"], name: "index_products_on_status"
    t.index ["title"], name: "index_products_on_title", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "promocodes", force: :cascade do |t|
    t.text "name", null: false
    t.integer "value", null: false
    t.datetime "valid_from", null: false
    t.datetime "valid_to", null: false
    t.boolean "repeatable", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_promocodes_on_name", unique: true
  end

  create_table "shop_order_products", force: :cascade do |t|
    t.bigint "shop_order_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_shop_order_products_on_product_id"
    t.index ["shop_order_id"], name: "index_shop_order_products_on_shop_order_id"
  end

  create_table "shop_orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "shop_id"
    t.string "status", default: "NEW"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "price"
    t.index ["order_id"], name: "index_shop_orders_on_order_id"
    t.index ["shop_id"], name: "index_shop_orders_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "address"
    t.bigint "phone_number"
    t.text "city"
    t.text "postcode"
    t.text "status", default: "pending", null: false
    t.text "company_number"
    t.text "legal_name"
    t.text "trading_name"
    t.text "contact_person_role"
    t.text "contact_person_first_name"
    t.text "contact_person_last_name"
    t.float "latitude"
    t.float "longitude"
    t.json "aux", default: {}
    t.index ["confirmation_token"], name: "index_shops_on_confirmation_token", unique: true
    t.index ["email"], name: "index_shops_on_email", unique: true
    t.index ["latitude", "longitude"], name: "index_shops_on_latitude_and_longitude"
    t.index ["reset_password_token"], name: "index_shops_on_reset_password_token", unique: true
  end

  create_table "submissions", force: :cascade do |t|
    t.json "form_fields"
    t.bigint "user_id"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "label"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "user_promocodes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "promocode_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promocode_id"], name: "index_user_promocodes_on_promocode_id"
    t.index ["user_id"], name: "index_user_promocodes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "first_name"
    t.text "last_name"
    t.date "birth_date"
    t.bigint "phone_number"
    t.text "postcode"
    t.json "aux", default: {}
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "opening_hours", "shops"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "shops"
  add_foreign_key "shop_order_products", "products"
  add_foreign_key "shop_order_products", "shop_orders"
  add_foreign_key "shop_orders", "orders"
  add_foreign_key "shop_orders", "shops"
  add_foreign_key "shops", "postcodes", column: "postcode", primary_key: "postcode"
  add_foreign_key "submissions", "users"
  add_foreign_key "user_promocodes", "promocodes"
  add_foreign_key "user_promocodes", "users"
end
