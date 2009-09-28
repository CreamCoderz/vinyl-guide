class Picture < ActiveRecord::Base
  belongs_to :ebay_item, :foreign_key => "ebay_item_id"
end