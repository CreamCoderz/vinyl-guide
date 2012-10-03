# Methods added to this helper will be available to all templates in the application.
require 'cgi'

module ApplicationHelper
  CURRENCY_SYMBOLS = {'USD' => '$', 'GBP' => '&pound;', 'AUD' => '$', 'CAD' => '$', 'CHF' => '?', 'CNY' => '&yen;', 'EUR' => '&euro;',
                      'HKD' => '$', 'INR' => 'INR', 'MYR' => 'MYR', 'PHP' => 'PHP', 'PLN' => 'PLN', 'SEK' => 'kr', 'SGD' => '$', 'TWD' => '$'}


  def display_gallery_img(ebay_item)
    ebay_item.gallery_image.url
  end

  def display_picture_img(picture)
    picture.image.url
  end

  def gallery_img_for(item)
    image_tag(display_gallery_img(item))
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
    date.to_time.strftime("%B %d, %Y - %I:%M:%S %p GMT")
  end

  def display_currency_symbol(currency_type)
    CURRENCY_SYMBOLS[currency_type]
  end

  def append_query_params(base_url, params)
    query = ""
    leading_char = base_url.include?("?") ? "&" : "?"
    params.each do |key_value_pair|
      value = key_value_pair[1]
      if value
        query += "#{leading_char}#{key_value_pair[0]}=#{value}"
        leading_char = "&"
      end
    end
    base_url + query
  end

  def header_text(format, page_results)
    if page_results.empty?
      "No #{format} Results"
    else
      "#{format} Results #{page_results.start_from}-#{page_results.end_on} of #{page_results.total}"
    end
  end

  def no_or_length(a)
    a.empty? ? "No" : a.length
  end

  def related_items(related_items)
    related_items.collect do |related_item|
      link_to "/#{related_item.id}" do
        %|<span><img src="#{display_gallery_img(related_item)}"/></span>"|
      end.concat('\n')
    end
  end

  def sort_link(link_title, field, parsed_params)
    html_options = {:class => ""}
    html_options[:class] += 'selected ' if parsed_params.selected?(:sort, field)
    html_options[:class] += (parsed_params.order.to_sym == :desc && parsed_params.selected?(:sort, field)) ? 'asc' : 'desc'

    query_params = {}
    query_params[:sort] = field
    query_params[:order] = (parsed_params.order.to_sym == :desc && parsed_params.selected?(:sort, field)) ? 'asc' : 'desc'
    query_params[:time] = parsed_params.time if parsed_params.declared?(:time)
    query_params[:q] = parsed_params.q if parsed_params.declared?(:q)

    link_to link_title, query_params, html_options
  end

  def full_error_messages(model)
    #todo: tag helpers.. y u no work here?!
    markup = ""
    if model.errors.full_messages.length > 0
      markup += "<ul>"
      model.errors.full_messages.each do |m|
        markup += "<li>#{m}</li>"
      end
      markup += "</ul>"
    end
    markup.html_safe
  end

  def relative_past_time(time)
    "#{time_ago_in_words(time)} ago"
  end
end
