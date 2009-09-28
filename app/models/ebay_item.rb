class EbayItem < ActiveRecord::Base
  validates_numericality_of :itemid, :only_integer => true
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :url

  has_many :pictures, :foreign_key => "ebay_item_id"

end