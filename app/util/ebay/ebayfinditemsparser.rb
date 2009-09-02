require 'cobravsmongoose'
require File.dirname(__FILE__) + "/../dateutil"

class EbayFindItemsParser

  def initialize(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    @num_total_items = 0
    @num_items_ignored = 0
    @parsed_items = []
    if !parsed_items['FindItemsAdvancedResponse']['SearchResult'].nil?
      items = parsed_items['FindItemsAdvancedResponse']['SearchResult']['ItemArray']['Item']
      if !items.is_a?(Array)
        items = [items]
      end
      @num_total_items = items.length
      items.each do |item|
        if (0 == item['BidCount']['$'].to_i)
          @num_items_ignored += 1
        else
          @parsed_items.insert(-1, [item['ItemID']['$'].to_i, DateUtil.utc_to_date(item['EndTime']['$'])])
        end
      end
      @page_number = parsed_items['FindItemsAdvancedResponse']['PageNumber']['$']
      @total_pages = parsed_items['FindItemsAdvancedResponse']['TotalPages']['$']
    end
  end

  def last_page
    @page_number == @total_pages
  end

  def get_items
    @parsed_items
  end

  def get_num_items_marked
    @parsed_items.length
  end

  def get_num_items_ignored
    @num_items_ignored
  end

  def get_num_total_items
    @num_total_items
  end

end