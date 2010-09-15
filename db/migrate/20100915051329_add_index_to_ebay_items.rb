class AddIndexToEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, :size
  end

  def self.down
    remove_index :ebay_items, :size
  end
end
