class AddIndexesToEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, [:title]
  end

  def self.down
    remove_index :ebay_items, :column => [:title]
  end
end
