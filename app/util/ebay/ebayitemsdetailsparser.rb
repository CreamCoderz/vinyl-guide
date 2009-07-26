require 'cobravsmongoose'
require 'time'
require 'activesupport'
require File.dirname(__FILE__) + "/../../domain/ebayitemdata"

class EbayItemsDetailsParser

  DESCRIPTION = 'Description'
  ITEMID = 'ItemID'
  ENDTIME = 'EndTime'
  STARTTIME = 'StartTime'
  URL = 'ViewItemURLForNaturalSearch'
  IMAGE = 'GalleryURL'
  BIDCOUNT = 'BidCount'
  PRICE = 'ConvertedCurrentPrice'
  SELLER = 'Seller'
  USERID = 'UserID'
  LEAFNODE_CONTENTS = '$'
  GETMULTIPLEITEMSRESPONSE = 'GetMultipleItemsResponse'
  ITEM = 'Item'

  def self.parse(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    items = parsed_items[GETMULTIPLEITEMSRESPONSE][ITEM]
    ebay_items = []
    if !items.is_a?(Array)
      items = [items]  
    end
    items.each do |item|
      ebay_items.insert(-1, EbayItemData.new(item[DESCRIPTION][LEAFNODE_CONTENTS],
      item[ITEMID][LEAFNODE_CONTENTS].to_i, Time.iso8601(item[ENDTIME][LEAFNODE_CONTENTS]).to_date,
              Time.iso8601(item[STARTTIME][LEAFNODE_CONTENTS]).to_date,
              item[URL][LEAFNODE_CONTENTS],item[IMAGE][LEAFNODE_CONTENTS],
              item[BIDCOUNT][LEAFNODE_CONTENTS].to_i, item[PRICE][LEAFNODE_CONTENTS].to_f,
              item[SELLER][USERID][LEAFNODE_CONTENTS]))
    end
    ebay_items
  end

end