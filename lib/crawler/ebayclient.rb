require 'activesupport'
require File.dirname(__FILE__) + "/../dateutil"
require File.dirname(__FILE__) + "/../crawler/ebayfinditemsparser"
require File.dirname(__FILE__) + "/../crawler/ebayitemsdetailsparser"
require File.dirname(__FILE__) + "/../crawler/ebaytimeparser"

class EbayClient
  FIND_ITEMS_CALL = 'FindItemsAdvanced'
  FIND_ITEMS_BASE_CALL = 'services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME='
  FIND_COUNTRY_DATA = {'EBAY-US' => 'Reggae%20%26%20Ska', 'EBAY-GB' => 'Reggae%2F+Ska'}

  GET_ITEM_DETAILS_CALL = 'GetMultipleItems'
  GET_EBAY_TIME = 'geteBayTime'
  ITEMS_PER_DETAILS_REQ = 20

  BASE_FIND_URL = 'http://svcs.ebay.com/'
  BASE_DETAILS_URL = 'http://open.api.ebay.com/'

  def initialize(web_client, api_key)
    @web_client = web_client
    @api_key = api_key
  end

  def find_items(end_time_from)
    end_time_from_utc = DateUtil.date_to_utc(end_time_from)
    results = []
    FIND_COUNTRY_DATA.each_pair do |global_id, sub_genre|
      is_last_page = false
      page_num = 1
      while !is_last_page
        find_items_url = generate_find_items_advanced_url(global_id, sub_genre, end_time_from_utc, page_num)
        response = @web_client.get(find_items_url)
        find_items_parser = EbayFindItemsParser.new(response.body)
        results.concat(find_items_parser.get_items)
        is_last_page = find_items_parser.last_page
        page_num += 1
      end
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
      item_details_url = generate_get_details_url(item_ids_query)
      response = @web_client.get(item_details_url)
      new_details = EbayItemsDetailsParser.parse(response.body)

      detailses.concat(new_details)
    end
    detailses
  end

  def get_current_time
    response = @web_client.get(generate_details_base + GET_EBAY_TIME)
    EbayTimeParser.parse(response.body)
  end

  private

  def generate_find_items_advanced_url(global_id, sub_genre, end_time, page_num)
    "#{BASE_FIND_URL}#{FIND_ITEMS_BASE_CALL}#{@api_key}&GLOBAL-ID=#{global_id}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&categoryId=306&aspectFilter%280%29.aspectName=Genre&aspectFilter%280%29.aspectValueName=#{sub_genre}&itemFilter.name=EndTimeTo&itemFilter.value=#{end_time}&paginationInput.pageNumber=#{page_num}"
  end

  def generate_get_details_url(item_ids_query)
    "#{generate_details_base}#{GET_ITEM_DETAILS_CALL}&IncludeSelector=Details,TextDescription,ItemSpecifics&ItemID=#{item_ids_query}"
  end

  def generate_details_base
    "#{BASE_DETAILS_URL}shopping?version=517&appid=#{@api_key}&callname="
  end
end