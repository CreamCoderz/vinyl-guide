class AddMoreIndexesToEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, [:endtime]
    add_index :ebay_items, [:price]
  end

  def self.down
    remove_index :ebay_items, :column => [:endtime]
    remove_index :ebay_items, :column => [:price]
  end
end