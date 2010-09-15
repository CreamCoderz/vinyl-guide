class AddIndexesToPictures < ActiveRecord::Migration
  def self.up
    add_index :pictures, :ebay_item_id
  end

  def self.down
    remove_index :pictures, :ebay_item_id
  end
end
