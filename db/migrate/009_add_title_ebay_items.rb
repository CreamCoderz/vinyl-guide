class AddTitleEbayItems  < ActiveRecord::Migration

  def self.up
    add_column(:ebay_items, :title, :string)
  end

  def self.down
    remove_column(:ebay_items, :title)
  end
end