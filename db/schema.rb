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

ActiveRecord::Schema.define(version: 20150903202618) do

  create_table "merchants", id: false, force: :cascade do |t|
    t.string "merchant_identifier", null: false
    t.string "name"
    t.binary "encrypted_token"
    t.string "marketplace"
    t.string "password_digest"
    t.string "email"
  end

  add_index "merchants", ["merchant_identifier"], name: "index_merchants_on_merchant_identifier", unique: true

  create_table "products", force: :cascade do |t|
    t.text     "title"
    t.text     "sellersku"
    t.text     "asin"
    t.text     "price"
    t.string   "merchant_identifier"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "products", ["merchant_identifier"], name: "index_products_on_merchant_identifier"

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true

end
