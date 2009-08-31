class EditTimeAndStringEbayItems  < ActiveRecord::Migration

  def self.up
    change_column :ebay_items, :endtime, :datetime
    change_column :ebay_items, :starttime, :datetime
    change_column :ebay_items, :description, :text
    change_column :ebay_items, :url, :text
  end

  def self.down
    change_column :ebay_items, :endtime, :time
    change_column :ebay_items, :starttime, :time
    change_column :ebay_items, :description, :string
    change_column :ebay_items, :url, :string
  end
end