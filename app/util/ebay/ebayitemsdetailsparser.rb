require 'cobravsmongoose'
require 'time'
require 'activesupport'
require File.dirname(__FILE__) + "/../../domain/ebayitemdata"
require File.dirname(__FILE__) + "/../dateutil"
require File.dirname(__FILE__) + "/../arrayutil"
require File.dirname(__FILE__) + "/ebayitemsdetailsparserdata"

class EbayItemsDetailsParser
  include EbayItemsDetailsParserData

  def self.parse(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    items = parsed_items[GETMULTIPLEITEMSRESPONSE][ITEM]
    ebay_items = []
    if (!items.nil?)
      items = ArrayUtil.arrayifiy(items)
      items.each do |item|
        image = nil
        if item[IMAGE]
          image = item[IMAGE][NODE_VALUE]
        end

        parsed_specifics = get_item_specifics(item)

        if (item['BidCount']['$'].to_i > 0)
          ebay_items.insert(-1, EbayItemData.new(item[DESCRIPTION][NODE_VALUE],
                  item[ITEMID][NODE_VALUE].to_i, DateUtil.utc_to_date(item[ENDTIME][NODE_VALUE]),
                  DateUtil.utc_to_date(item[STARTTIME][NODE_VALUE]),
                  item[URL][NODE_VALUE], image,
                  item[BIDCOUNT][NODE_VALUE].to_i, item[PRICE][NODE_VALUE].to_f,
                  item[SELLER][USERID][NODE_VALUE], item[TITLE][NODE_VALUE], item[COUNTRY][NODE_VALUE], get_picture_imgs(item), item[PRICE][CURRENCY_ID],
                  parsed_specifics[RECORDSIZE], parsed_specifics[SUBGENRE], parsed_specifics[CONDITION], parsed_specifics[SPEED]))
        end
      end
    end
    ebay_items
  end

  private

  def self.get_picture_imgs(item)
    picture_nodes = item[PICTURE]
    pictures = nil
    if picture_nodes
      picture_nodes = ArrayUtil.arrayifiy(picture_nodes)
      pictures = picture_nodes.map do |picture_node|
        picture_node[NODE_VALUE]
      end
    end
    pictures
  end

  def self.get_item_specifics(item)
    parsed_specifics = {RECORDSIZE => nil, SUBGENRE => nil, CONDITION => nil, SPEED => nil}
    if item[ITEMSPECIFICS]
      item_specifics = item[ITEMSPECIFICS][NAMEVALUELIST]
      item_specifics = ArrayUtil.arrayifiy(item_specifics)
      item_specifics.each do |item_specific|
        if parsed_specifics.key? item_specific[NAME][NODE_VALUE]
          parsed_specifics[item_specific[NAME][NODE_VALUE]] = item_specific[VALUE][NODE_VALUE]
        end
      end
    end
    return parsed_specifics
  end
end