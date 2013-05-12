class EbayFindItemsParser

  def initialize(xml)
    parsed_items = CobraVsMongoose.xml_to_hash(xml)
    @num_total_items = 0
    @parsed_items = []
    if !parsed_items['findItemsAdvancedResponse']['searchResult']['item'].nil?
      items = parsed_items['findItemsAdvancedResponse']['searchResult']['item']
      items = ArrayUtil.arrayifiy(items)
      @num_total_items = items.length
      items.each do |item|
        @parsed_items.insert(-1, [item['itemId']['$'].to_i, DateUtil.utc_to_date(item['listingInfo']['endTime']['$'])])
      end
      @page_number = parsed_items['findItemsAdvancedResponse']['paginationOutput']['pageNumber']['$']
      @total_pages = parsed_items['findItemsAdvancedResponse']['paginationOutput']['totalPages']['$']
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

  def get_num_total_items
    @num_total_items
  end

  def total_pages
    @total_pages.to_i
  end
end