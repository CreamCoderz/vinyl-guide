class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :ebay_item

  validates_presence_of :user
  validates_presence_of :ebay_item
  validates_uniqueness_of :user_id, :scope => :ebay_item_id, :message => '- You have already added this item to your favorites!'

  scope :for_ebay_items, lambda { |ebay_items| where("ebay_item_id IN (?)", ebay_items) }
end