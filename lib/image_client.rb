require File.expand_path(File.dirname(__FILE__) + "/crawler/ebay_logger")
include EbayLogger

class ImageClient

  def initialize(webclient)
    @webclient = webclient
  end

  def fetch(url)
    image_content = nil
    begin
      response = @webclient.get(url)
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