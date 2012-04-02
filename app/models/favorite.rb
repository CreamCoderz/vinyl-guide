class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :ebay_item

  validates_presence_of :user
  validates_presence_of :ebay_item

  scope :for_ebay_items, lambda { |ebay_items| where("ebay_item_id IN (?)", ebay_items) }
end