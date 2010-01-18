require File.expand_path(File.dirname(__FILE__) + "/ebay/ebaylogger")
include EbayLogger

class ImageClient

  def initialize(webclient)
    @webclient = webclient
  end

  def fetch(url)
    begin
      response = @webclient.get(url)
      if response.kind_of?(Net::HTTPSuccess) && response['content-type'] == 'image/jpeg'
        return response.body
      end
    rescue Exception => e
      EBAY_CRAWLER_LOGGER.error("#{Time.new} - error fetching image for url: #{url}")
      EBAY_CRAWLER_LOGGER.error(e)
    end
  end
end