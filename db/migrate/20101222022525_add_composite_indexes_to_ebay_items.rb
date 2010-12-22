class AddCompositeIndexesToEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, [:endtime, :price]
    add_index :ebay_items, [:endtime, :title]
    remove_index :ebay_items, :created_at
  end

  def self.down
    remove_index :ebay_items, [:endtime, :price]
    remove_index :ebay_items, [:endtime, :title]
    add_index :ebay_items, :created_at
  end
end
