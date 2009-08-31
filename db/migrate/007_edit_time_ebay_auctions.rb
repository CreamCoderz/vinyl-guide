class EditTimeEbayAuctions  < ActiveRecord::Migration

  def self.up
    change_column :ebay_auctions, :end_time, :datetime
  end

  def self.down
    change_column :ebay_auctions, :end_time, :time
  end
end