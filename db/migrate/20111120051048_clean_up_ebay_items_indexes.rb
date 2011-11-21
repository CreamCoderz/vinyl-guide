class CleanUpEbayItemsIndexes < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, ["price", "format_id"]
    add_index :ebay_items, ["title", "format_id"]
    add_index :ebay_items, ["format_id", "price"]
    add_index :ebay_items, ["format_id", "title"]
    add_index :ebay_items, ["format_id", "endtime"]

    remove_index :ebay_items, ["endtime", "price"]
    remove_index :ebay_items, ["price"]
    remove_index :ebay_items, ["endtime", "title"]
  end

  def self.down
    remove_index :ebay_items, ["price", "format_id"]
    remove_index :ebay_items, ["title", "format_id"]
    remove_index :ebay_items, ["format_id", "price"]
    remove_index :ebay_items, ["format_id", "title"]
    remove_index :ebay_items, ["format_id", "endtime"]

    add_index :ebay_items, ["endtime", "price"]
    add_index :ebay_items, ["price"]
    add_index :ebay_items, ["endtime", "title"]
  end
end
