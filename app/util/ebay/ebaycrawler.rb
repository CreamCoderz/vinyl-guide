class EbayCrawler

  CRAWLING_INTERVAL_SECONDS = 20 * 60

  def initialize(ebay_client)
    @ebay_client = ebay_client
  end

  def crawl
    current_time = @ebay_client.get_current_time
    @ebay_client.find_items(current_time, current_time + EbayCrawler::CRAWLING_INTERVAL_SECONDS)
  end
end