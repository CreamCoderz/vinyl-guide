require 'cobravsmongoose'
require 'time'
require 'activesupport'
require File.dirname(__FILE__) + "/../../domain/ebayitemdata"
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
        if (item['BidCount']['$'].to_i > 0)
          parsed_specifics = extract_value(ITEMSPECIFICS, item)
          #TODO: please tear out exception handling!! or test something like it              
          begin
            ebay_items.insert(-1, EbayItemData.new(extract_value(DESCRIPTION, item),
                    extract_value(ITEMID, item), extract_value(ENDTIME, item),
                    extract_value(STARTTIME, item), extract_value(URL, item), extract_value(IMAGE, item),
                    extract_value(BIDCOUNT, item), extract_value(PRICE, item),
                    extract_value(USERID, item[SELLER]), extract_value(TITLE, item),
                    extract_value(COUNTRY, item), extract_value(PICTURE, item), extract_value(CURRENCY_ID, item[PRICE]),
                    parsed_specifics[RECORDSIZE], parsed_specifics[SUBGENRE], parsed_specifics[CONDITION], parsed_specifics[SPEED]))
          rescue Exception => e
            puts "problem with itemid: #{extract_value(ITEMID, item)}"              
          end
        end
      end
    end
    ebay_items
  end

  private

  def self.extract_value(field, node)
    #TODO: please tear out exception handling!! or test something like it
    begin
      VALUE_EXTRACTOR[field].call(node[field])
    rescue Exception => e
      puts "problem with nil field: #{field} node: #{node}"
      raise Exception
    end

  end

end