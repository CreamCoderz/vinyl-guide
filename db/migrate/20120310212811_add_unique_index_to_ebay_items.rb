class AddUniqueIndexToEbayItems < ActiveRecord::Migration
  def self.up
    remove_index :ebay_items, :itemid
    add_index :ebay_items, :itemid, :unique => true
  end

  def self.down
    remove_index :ebay_items, :itemid
    add_index :ebay_items, :itemid
  end
end
