# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161114091549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alterations", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "alteration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
  end

  add_index "alterations", ["item_id"], name: "index_alterations_on_item_id", using: :btree
  add_index "alterations", ["order_id"], name: "index_alterations_on_order_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.string   "sender_id"
    t.string   "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "unique_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "order_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "item_name"
    t.string   "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "items", ["order_id"], name: "index_items_on_order_id", using: :btree

  create_table "measurements", force: :cascade do |t|
    t.integer  "sleeve_length"
    t.integer  "shoulder_to_waist"
    t.integer  "chest_bust"
    t.integer  "upper_torso"
    t.integer  "waist"
    t.integer  "pant_length"
    t.integer  "hips"
    t.integer  "thigh"
    t.integer  "knee"
    t.integer  "calf"
    t.integer  "ankle"
    t.integer  "back_width"
    t.integer  "bicep"
    t.integer  "elbow"
    t.integer  "forearm"
    t.integer  "inseam"
    t.string   "customer_name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.string   "text"
    t.boolean  "read"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "user_read"
    t.string   "order_id"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.string   "shopify_id"
    t.string   "unique_id"
    t.string   "total"
    t.string   "alterations"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "arrival_date"
    t.boolean  "complete"
    t.boolean  "arrived"
    t.datetime "due_date"
    t.string   "customer_id"
    t.string   "weight"
    t.string   "shipping_label"
    t.integer  "counter"
    t.text     "note"
    t.string   "inbound_label"
    t.integer  "inbound_counter"
    t.boolean  "welcome"
    t.string   "tracker"
    t.string   "tracking_number"
    t.boolean  "conversation"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "shipments", force: :cascade do |t|
    t.string   "shopify_id"
    t.string   "shipment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "business_name"
    t.string   "user_name"
    t.string   "phone"
    t.string   "street"
    t.string   "unit"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "timezone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "conversation"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "alterations", "items"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "orders", "users"
end
