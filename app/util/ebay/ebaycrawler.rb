class EbayCrawler

  def initialize(web_client)
    @web_client = web_client
  end

  def find_items
    @web_client.get('http://open.api.ebay.com/shopping?version=517&appid=WillSulz-7420-475d-9a40-2fb8b491a6fd&callname=FindItemsAdvanced&MessageID=the%20message&CategoryID=306&DescriptionSearch=true&EndTimeFrom=2009-07-09T01:00:00.000Z&EndTimeTo=2009-07-10T01:00:00.000Z&MaxEntries=100&PageNumber=1&QueryKeywords=reggae')  
  end
end