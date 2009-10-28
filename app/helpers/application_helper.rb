# Methods added to this helper will be available to all templates in the application.
require 'cgi'

module ApplicationHelper
  CURRENCY_SYMBOLS = {'USD' => '$', 'GBP' => '&pound;', 'AUD' => '$', 'CAD' => '$', 'CHF' => '?', 'CNY' => '&yen;', 'EUR' => '&euro;',
          'HKD' => '$', 'INR' => 'INR', 'MYR' => 'MYR', 'PHP' => 'PHP', 'PLN' => 'PLN', 'SEK' => 'kr', 'SGD' => '$', 'TWD' => '$'}

  def display_gallery_img(url)
    if url.nil?
      return "/images/noimage.jpg"
    else
      return url
    end
  end

  def unescape_html(html)
    CGI.unescapeHTML(html)
  end

  def html_escape(html)
    CGI.escapeHTML(html)
  end

  def url_escape(html)
    CGI.escape(html)
  end

  def paginate(page_num, items)
    start_index = (page_num - 1) * PAGE_LIMIT
    end_index = start_index + PAGE_LIMIT - 1
    truncated_items = items[start_index..end_index]
    prev_page_num = (page_num > 1) ? page_num - 1 : nil
    #TODO: find a better way to calculate the next link
    before_end = items.length != end_index + 1
    next_page_num = (before_end && truncated_items.length >= PAGE_LIMIT) ? page_num + 1 : nil
    start_from = start_index + 1
    end_on = start_index + truncated_items.length
    total = items.length
    return truncated_items, prev_page_num, next_page_num, start_from, end_on, total
  end

  def display_date(date)
    date.to_time.strftime("%B %d, %Y - %I:%M:%S %p")
  end

  def display_currency_symbol(currency_type)
    CURRENCY_SYMBOLS[currency_type]
  end
end
