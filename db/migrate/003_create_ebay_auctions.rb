class CreateEbayAuctions  < ActiveRecord::Migration

  def self.up
    create_table :ebay_auctions do |t|
      t.integer :item_id
      t.time :end_time
    end
  end

  def self.down
      drop_table :ebay_auctions
  end

end