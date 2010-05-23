class AddIndexesToEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, :description, :text
    add_index :ebay_items, :title, :string
  end

  def self.down
    remove_index :ebay_items, :description
    remove_index :ebay_items, :title
  end
end
