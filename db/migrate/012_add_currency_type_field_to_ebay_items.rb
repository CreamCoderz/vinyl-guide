class AddCurrencyTypeFieldToEbayItems < ActiveRecord::Migration

  def self.up
    add_column(:ebay_items, :currencytype, :string)
    EbayItem.find(:all).each do |ebay_item|
      ebay_item.currencytype = 'USD'
      ebay_item.save
    end
  end

  def self.down
    remove_column(:ebay_items, :currencytype)
  end

end