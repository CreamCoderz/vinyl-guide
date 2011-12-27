require File.expand_path(File.dirname(__FILE__) + "/crawler/ebay_logger")
include EbayLogger

module ImageClient

  def fetch(url)
    image_content = nil
    begin
      response = WebClient.get(url)
      if response.kind_of?(Net::HTTPSuccess) && response['content-type'] == 'image/jpeg'
        image_content = response.body
      end
    rescue Exception => e
      EBAY_CRAWLER_LOGGER.error("#{Time.new} - error fetching image for url: #{url}")
      EBAY_CRAWLER_LOGGER.error(e.inspect)
    end
    image_content
  end
end