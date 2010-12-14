class AddIndexesToEbayItem < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, :created_at
  end

  def self.down
    remove_index :ebay_items, :created_at
  end
end
