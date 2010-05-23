class AddReleaseIdToEbayItem < ActiveRecord::Migration
  def self.up
    add_column :ebay_items, :release_id, :integer
  end

  def self.down
    remove_column :ebay_items, :release_id
  end
end
