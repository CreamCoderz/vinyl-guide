require File.dirname(__FILE__) + '/ebay_find_items_parser'
require File.dirname(__FILE__) + '/ebay_items_details_parser'
require File.dirname(__FILE__) + '/ebay_time_parser'

class EbayClient
  FIND_ITEMS_CALL = 'FindItemsAdvanced'
  FIND_ITEMS_BASE_CALL = 'services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME='
  FIND_COUNTRY_DATA = ['EBAY-US', 'EBAY-GB']

  GET_ITEM_DETAILS_CALL = 'GetMultipleItems'
  GET_EBAY_TIME = 'geteBayTime'
  ITEMS_PER_DETAILS_REQ = 20

  BASE_FIND_URL = 'http://svcs.ebay.com/'
  BASE_DETAILS_URL = 'http://open.api.ebay.com/'

  CATEGORY_ID = 176985

  def initialize(api_key)
    @api_key = api_key
  end

  def find_items(end_time_from)
    end_time_from_utc = DateUtil.date_to_utc(end_time_from)
    results = []
    hydra = Typhoeus::Hydra.new(:max_concurrency => 5)

    FIND_COUNTRY_DATA.each do |global_id|
      #query for total pages
      find_items_url = generate_find_items_url(:global_id => global_id, :end_time => end_time_from_utc, :page_num => 1)
      first_page_response = Typhoeus::Request.get(find_items_url).body
      total_pages = EbayFindItemsParser.new(first_page_response).total_pages
      p "total pages: #{total_pages}"

      #query for auction data
      1.upto(total_pages) do |page_num|
        find_items_url = generate_find_items_url(:end_time => end_time_from_utc, :global_id => global_id, :page_num => page_num)
        request = configure_find_items_request(find_items_url, results)
        hydra.queue(request)
      end

      hydra.run
    end
    results
  end

  def get_details(item_ids)
    num_of_requests = (item_ids.length / ITEMS_PER_DETAILS_REQ).ceil
    detailses = []
    hydra = Typhoeus::Hydra.new(:max_concurrency => 5)

    1.upto(num_of_requests) do |page_num|
      item_details_url = generate_get_details_url(item_ids, page_num)
      request = configure_get_details_request(item_details_url, detailses)
      hydra.queue(request)
      hydra.run
      detailses.each { |new_detail| yield new_detail } if detailses.present?
    end

    detailses
  end

  def get_current_time
    response = WebClient.get(generate_details_base + GET_EBAY_TIME)
    EbayTimeParser.parse(response.body)
  end

  private

  def configure_find_items_request(find_items_url, results)
    request = Typhoeus::Request.new(find_items_url)
    request.on_complete do |response|
      p "processed request: #{response.request.url}"
      find_items_parser = EbayFindItemsParser.new(response.body)
      results.concat(find_items_parser.get_items)
    end
    request
  end

  def configure_get_details_request(item_details_url, detailses)
    request = Typhoeus::Request.new(item_details_url)
    request.on_complete do |response|
      p "processed request: #{response.request.url}"
      new_details = EbayItemsDetailsParser.parse(response.body)
      detailses.concat(new_details)
    end
    request
  end

  def generate_find_items_url(options)
    global_id, end_time, page_num = options[:global_id], options[:end_time], options[:page_num]
    "#{BASE_FIND_URL}#{FIND_ITEMS_BASE_CALL}#{@api_key}&GLOBAL-ID=#{global_id}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&categoryId=#{CATEGORY_ID}&itemFilter.name=EndTimeTo&itemFilter.value=#{end_time}&paginationInput.pageNumber=#{page_num}"
  end

  def generate_get_details_url(item_ids, page_num)
    start_pos = (page_num-1) * ITEMS_PER_DETAILS_REQ
    item_ids_query = item_ids[start_pos..[(start_pos + ITEMS_PER_DETAILS_REQ)-1, item_ids.length].min].join(',')
    "#{generate_details_base}#{GET_ITEM_DETAILS_CALL}&IncludeSelector=Details,TextDescription,ItemSpecifics&ItemID=#{item_ids_query}"
  end

  def generate_details_base
    "#{BASE_DETAILS_URL}shopping?version=517&appid=#{@api_key}&callname="
  end
end
