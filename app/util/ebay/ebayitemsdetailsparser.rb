require 'cobravsmongoose'
require 'time'
require 'activesupport'
require File.dirname(__FILE__) + "/../../domain/ebayitemdata"
require File.dirname(__FILE__) + "/../dateutil"

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
  TITLE = 'Title'

  def self.parse(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    items = parsed_items[GETMULTIPLEITEMSRESPONSE][ITEM]
    ebay_items = []
    if (!items.nil?)
      #TODO: duplicate code in ebayfinditemsparser
      if !items.is_a?(Array)
        items = [items]
      end
      items.each do |item|
        image = nil
        if !item[IMAGE].nil?
          image = item[IMAGE][LEAFNODE_CONTENTS]
        end
        ebay_items.insert(-1, EbayItemData.new(item[DESCRIPTION][LEAFNODE_CONTENTS],
                item[ITEMID][LEAFNODE_CONTENTS].to_i, DateUtil.utc_to_date(item[ENDTIME][LEAFNODE_CONTENTS]),
                DateUtil.utc_to_date(item[STARTTIME][LEAFNODE_CONTENTS]),
                item[URL][LEAFNODE_CONTENTS], image,
                item[BIDCOUNT][LEAFNODE_CONTENTS].to_i, item[PRICE][LEAFNODE_CONTENTS].to_f,
                item[SELLER][USERID][LEAFNODE_CONTENTS], item[TITLE][LEAFNODE_CONTENTS]))
      end
    end
    ebay_items
  end

end