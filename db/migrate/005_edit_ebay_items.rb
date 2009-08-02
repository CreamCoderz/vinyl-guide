class EditEbayItems  < ActiveRecord::Migration

  def self.up
    change_column :ebay_items, :itemid, :bigint
  end

  def self.down
    change_column :ebay_items, :itemid, :integer    
  end
end