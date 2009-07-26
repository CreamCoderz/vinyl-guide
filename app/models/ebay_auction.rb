class EbayAuction < ActiveRecord::Base
  validates_numericality_of :item_id, :only_integer => true
  validates_uniqueness_of :item_id, :scope => :item_id
  validates_presence_of :end_time
end