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

ActiveRecord::Schema.define(version: 20150917192610) do

  create_table "merchants", force: :cascade do |t|
    t.string "merchant_identifier", null: false
    t.string "name"
    t.binary "encrypted_token"
    t.string "marketplace"
    t.string "password_digest"
    t.string "email"
    t.string "domain"
  end

  create_table "products", force: :cascade do |t|
    t.text     "title"
    t.text     "sellersku"
    t.text     "asin"
    t.text     "price"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "description"
    t.text     "bullets"
    t.string   "package_height"
    t.string   "package_length"
    t.string   "vendor"
    t.string   "product_type"
    t.string   "color"
    t.binary   "image"
    t.string   "package_width"
    t.string   "size"
    t.string   "weight"
    t.string   "compare_at_price"
    t.integer  "merchant_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true

end
