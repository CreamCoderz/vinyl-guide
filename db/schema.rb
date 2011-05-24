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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110504025254) do

  create_table "ebay_auctions", :force => true do |t|
    t.integer  "item_id",  :limit => 8
    t.datetime "end_time"
  end

  create_table "ebay_items", :force => true do |t|
    t.integer  "itemid",       :limit => 8
    t.text     "description"
    t.integer  "bidcount"
    t.float    "price"
    t.datetime "endtime"
    t.datetime "starttime"
    t.text     "url"
    t.string   "galleryimg"
    t.string   "sellerid"
    t.string   "title"
    t.string   "size"
    t.string   "speed"
    t.string   "condition"
    t.string   "subgenre"
    t.string   "country"
    t.string   "currencytype"
    t.boolean  "hasimage"
    t.integer  "release_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "format_id"
  end

  add_index "ebay_items", ["endtime", "price"], :name => "index_ebay_items_on_endtime_and_price"
  add_index "ebay_items", ["endtime", "title"], :name => "index_ebay_items_on_endtime_and_title"
  add_index "ebay_items", ["endtime"], :name => "index_ebay_items_on_endtime"
  add_index "ebay_items", ["format_id"], :name => "index_ebay_items_on_format_id"
  add_index "ebay_items", ["itemid"], :name => "index_ebay_items_on_itemid"
  add_index "ebay_items", ["price"], :name => "index_ebay_items_on_price"
  add_index "ebay_items", ["release_id"], :name => "index_ebay_items_on_release_id"
  add_index "ebay_items", ["size"], :name => "index_ebay_items_on_size"
  add_index "ebay_items", ["title"], :name => "index_ebay_items_on_title"

  create_table "formats", :force => true do |t|
    t.string "name"
  end

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.integer "ebay_item_id"
    t.string  "url"
    t.boolean "hasimage"
  end

  add_index "pictures", ["ebay_item_id"], :name => "index_pictures_on_ebay_item_id"

  create_table "releases", :force => true do |t|
    t.string   "title"
    t.string   "artist"
    t.integer  "year"
    t.string   "matrix_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "format_id"
    t.integer  "label_id"
  end

  add_index "releases", ["label_id"], :name => "index_releases_on_label_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
