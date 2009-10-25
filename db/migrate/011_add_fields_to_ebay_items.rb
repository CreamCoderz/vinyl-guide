class AddFieldsToEbayItems < ActiveRecord::Migration

  def self.up
    add_column(:ebay_items, :size, :string)
    add_column(:ebay_items, :speed, :string)
    add_column(:ebay_items, :condition, :string)
    add_column(:ebay_items, :subgenre, :string)
    add_column(:ebay_items, :country, :string)
  end

  def self.down
    remove_column(:ebay_items, :size)
    remove_column(:ebay_items, :speed)
    remove_column(:ebay_items, :condition)
    remove_column(:ebay_items, :subgenre)
    remove_column(:ebay_items, :country)
  end
end