require 'ActiveSupport'
require File.dirname(__FILE__) + "/../dateutil"
require File.dirname(__FILE__) + "/../ebay/ebayfinditemsparser"
require File.dirname(__FILE__) + "/../ebay/ebayitemsdetailsparser"

class EbayCrawler
  APP_ID = 'WillSulz-7420-475d-9a40-2fb8b491a6fd'
  FIND_ITEMS_CALL = 'FindItemsAdvanced'
  GET_ITEM_DETAILS_CALL = 'GetMultipleItems'
  BASE_URL = 'http://open.api.ebay.com/shopping?version=517&appid=' + APP_ID + '&callname='

  def initialize(web_client)
    @web_client = web_client
  end

  def find_items(end_time_from, end_time_to)
    end_time_from_utc = DateUtil.date_to_utc(end_time_from)
    end_time_to_utc = DateUtil.date_to_utc(end_time_to)
    response = @web_client.get(BASE_URL + FIND_ITEMS_CALL.to_s + '&CategoryID=306&DescriptionSearch=true' +
            '&EndTimeFrom=' + end_time_from_utc.to_s + '&EndTimeTo=' + end_time_to_utc.to_s +
            '&MaxEntries=100' + '&PageNumber=1&QueryKeywords=reggae')
    find_items_parser = EbayFindItemsParser.new(response.body)
    find_items_parser.get_items
  end

  def get_details(item_ids)
    item_ids_query = '&ItemID='
    first = true
    item_ids_query = item_ids.join(',')
    response = @web_client.get(BASE_URL + GET_ITEM_DETAILS_CALL.to_s +
            '&IncludeSelector=Details,TextDescription&ItemID=' + item_ids_query)
    EbayItemsDetailsParser.parse(response.body)
  end
end