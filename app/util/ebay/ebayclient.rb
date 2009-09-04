require 'activesupport'
require File.dirname(__FILE__) + "/../dateutil"
require File.dirname(__FILE__) + "/../ebay/ebayfinditemsparser"
require File.dirname(__FILE__) + "/../ebay/ebayitemsdetailsparser"
require File.dirname(__FILE__) + "/../ebay/ebaytimeparser"

class EbayClient
  APP_ID = 'WillSulz-7420-475d-9a40-2fb8b491a6fd'
  FIND_ITEMS_CALL = 'FindItemsAdvanced'
  GET_ITEM_DETAILS_CALL = 'GetMultipleItems'
  GET_EBAY_TIME = 'geteBayTime'
  ITEMS_PER_DETAILS_REQ = 20

  BASE_URL = 'http://open.api.ebay.com/shopping?version=517&appid=' + APP_ID + '&callname='

  def initialize(web_client)
    @web_client = web_client
  end

  def find_items(end_time_from, end_time_to)
    end_time_from_utc = DateUtil.date_to_utc(end_time_from)
    end_time_to_utc = DateUtil.date_to_utc(end_time_to)
    is_last_page = false
    results = []
    page_num = 1
    while !is_last_page
      find_items_url = BASE_URL + FIND_ITEMS_CALL.to_s + '&CategoryID=306&DescriptionSearch=true' +
              '&EndTimeFrom=' + end_time_from_utc.to_s + '&EndTimeTo=' + end_time_to_utc.to_s +
              '&MaxEntries=100' + '&PageNumber=' + page_num.to_s + '&QueryKeywords=reggae'
      response = @web_client.get(find_items_url)
      find_items_parser = EbayFindItemsParser.new(response.body)
      results.concat(find_items_parser.get_items)
      is_last_page = find_items_parser.last_page
      page_num += 1
    end
    results
  end

  def get_details(item_ids)
    item_ids_query = '&ItemID='
    first = true
    num_of_requests = (item_ids.length / ITEMS_PER_DETAILS_REQ).ceil
    detailses = []
    for i in 0..num_of_requests
      start_pos = (i * ITEMS_PER_DETAILS_REQ)
      item_ids_query = item_ids[start_pos..[(start_pos + ITEMS_PER_DETAILS_REQ)-1, item_ids.length].min].join(',')
      item_details_url = BASE_URL + GET_ITEM_DETAILS_CALL.to_s +
              '&IncludeSelector=Details,TextDescription&ItemID=' + item_ids_query
      response = @web_client.get(item_details_url)
      detailses.concat(EbayItemsDetailsParser.parse(response.body))
    end
    detailses
  end

  def get_current_time
    response = @web_client.get(BASE_URL + GET_EBAY_TIME)
    EbayTimeParser.parse(response.body)
  end

end