require 'cobravsmongoose'

class EbayFinderItemsParser

  def initialize(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    items = parsed_items['FindItemsAdvancedResponse']['SearchResult']['ItemArray']['Item']
    @num_total_items = items.length
    @num_items_ignored = 0
    @parsed_items = []
    items.each do |item|
      if (0 == item['BidCount']['$'].to_i)
        @num_items_ignored += 1
      else
        @parsed_items.insert(-1, item['ItemID']['$'].to_i)
      end
    end
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