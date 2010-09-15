class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, :release_id
    add_index :releases, :label_id
  end

  def self.down
    remove_index :ebay_items, :release_id
    remove_index :releases, :label_id
  end
end
