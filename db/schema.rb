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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130502055557) do

  create_table "comments", :force => true do |t|
    t.integer  "parent_id"
    t.string   "parent_type", :default => "EbayItem"
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["parent_id", "parent_type"], :name => "index_comments_on_parent_id_and_parent_type"

  create_table "ebay_auctions", :force => true do |t|
    t.integer  "item_id",  :limit => 8
    t.datetime "end_time"
  end

  create_table "ebay_items", :force => true do |t|
    t.integer  "itemid",        :limit => 8
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
    t.string   "gallery_image"
    t.string   "slug"
    t.string   "genrename"
    t.integer  "genre_id"
  end

  add_index "ebay_items", ["endtime"], :name => "index_ebay_items_on_endtime"
  add_index "ebay_items", ["format_id", "endtime"], :name => "index_ebay_items_on_format_id_and_endtime"
  add_index "ebay_items", ["format_id", "price"], :name => "index_ebay_items_on_format_id_and_price"
  add_index "ebay_items", ["format_id", "title"], :name => "index_ebay_items_on_format_id_and_title"
  add_index "ebay_items", ["genre_id", "format_id"], :name => "index_ebay_items_on_genre_id_and_format_id"
  add_index "ebay_items", ["itemid"], :name => "index_ebay_items_on_itemid"
  add_index "ebay_items", ["price", "format_id"], :name => "index_ebay_items_on_price_and_format_id"
  add_index "ebay_items", ["release_id"], :name => "index_ebay_items_on_release_id"
  add_index "ebay_items", ["slug"], :name => "index_ebay_items_on_slug", :unique => true
  add_index "ebay_items", ["title", "format_id"], :name => "index_ebay_items_on_title_and_format_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ebay_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "formats", :force => true do |t|
    t.string "name"
  end

  create_table "genre_aliases", :force => true do |t|
    t.string   "name"
    t.integer  "genre_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "genre_aliases", ["name"], :name => "index_genre_aliases_on_name"

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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
    t.string  "image"
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
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
