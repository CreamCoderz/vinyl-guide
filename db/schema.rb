# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "ebay_auctions", :force => true do |t|
    t.integer  "item_id",  :limit => 8
    t.datetime "end_time"
  end

  create_table "ebay_items", :force => true do |t|
    t.integer  "itemid",      :limit => 8
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
  end

  create_table "pictures", :force => true do |t|
    t.integer "ebay_item_id"
    t.string  "url"
  end

  create_table "records", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "artist"
    t.string   "img_src"
    t.string   "producer"
    t.string   "band"
    t.string   "engineer"
    t.string   "studio"
  end

end
