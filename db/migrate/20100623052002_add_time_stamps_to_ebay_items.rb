class AddTimeStampsToEbayItems < ActiveRecord::Migration
  def self.up
    change_table :ebay_items do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column(:ebay_items, :updated_at)
    remove_column(:ebay_items, :created_at)
  end
end
