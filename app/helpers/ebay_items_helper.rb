module EbayItemsHelper
  
  def header_text(format, page_results)
    "#{format} Results #{page_results.start_from}-#{page_results.end_on} of #{page_results.total}"
  end
end