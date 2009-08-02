class EditEbayAuctions  < ActiveRecord::Migration

  def self.up
    change_column :ebay_auctions, :item_id, :bigint
  end

  def self.down
    change_column :ebay_auctions, :item_id, :integer
  end
end