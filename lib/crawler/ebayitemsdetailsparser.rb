require 'cobravsmongoose'
require 'time'
require 'activesupport'
require File.dirname(__FILE__) + "/../../app/domain/ebayitemdata"
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
          begin
            ebay_items.insert(-1, EbayItemData.new(
                    :description => extract_value(DESCRIPTION, item),
                            :itemid => extract_value(ITEMID, item),
                            :endtime => extract_value(ENDTIME, item),
                            :starttime => extract_value(STARTTIME, item),
                            :url => extract_value(URL, item),
                            :galleryimg => extract_value(IMAGE, item),
                            :bidcount => extract_value(BIDCOUNT, item),
                            :price => extract_value(PRICE, item),
                            :sellerid => extract_value(USERID, item[SELLER]),
                            :title => extract_value(TITLE, item),
                            :country => extract_value(COUNTRY, item),
                            :pictureimgs => extract_value(PICTURE, item),
                            :currencytype => extract_value(CURRENCY_ID, item[PRICE]),
                            :size => parsed_specifics[RECORDSIZE],
                            :subgenre => parsed_specifics[SUBGENRE],
                            :condition => parsed_specifics[CONDITION],
                            :speed => parsed_specifics[SPEED]))
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