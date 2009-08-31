module BaseTestCase
  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']
  DISPLAY_AS_LINK = lambda {|href| "<a href=\"" + href + "\">" + href + "</a>"}
  DISPLAY_AS_IMG = lambda {|src| "<img src=\"" + src + "\" />"}
  ESCAPE_HTML = lambda {|html| CGI.escapeHTML(html)}
  TO_S = lambda {|arg| arg.to_s}
  PARSE_TIME = lambda {|time_string| Time.parse(time_string)}

  EBAY_ITEM_DISPLAY_FIELDS = [['itemid', TO_S], ['description', ESCAPE_HTML], ['bidcount', TO_S], ['price', TO_S], ['endtime', TO_S], ['starttime', TO_S], ['url', DISPLAY_AS_LINK], ['galleryimg', DISPLAY_AS_IMG], 'sellerid']

  RECORD_INPUT_TYPE_FIELDS = Array.new(RECORD_DISPLAY_FIELDS);
  RECORD_INPUT_TYPE_FIELDS.delete('date')

  RECORD_SEARCHABLE_FIELDS = ['artist', 'name', 'description', 'producer', 'band', 'engineer', 'studio'];

   def check_record_fields selector_path, record_input_type_fields, assertions, expected_record=nil
    assert_select selector_path do |input_fields|
      check_record_field(assertions, input_fields, record_input_type_fields, expected_record)
    end
   end

  #TODO: this method should go away once all usages are updated
  def check_record_field assertions, input_fields, record_input_type_fields, expected_record
    count = 0    
    assert_equal record_input_type_fields.length, input_fields.length
    input_fields.each do |input_field|
      expected_name = record_input_type_fields[count]
      assertions.each do |assertion|
        assertion.call(input_field, expected_name)
      end
      count += 1
    end
  end

  def check_record_field_with_extraction assertions, input_fields, record_input_type_fields, expected_record
    count = 0
    assert_equal record_input_type_fields.length, input_fields.length
    input_fields.each do |input_field|
      expected_name = record_input_type_fields[count]
      assertions.each do |assertion|
        assertion.call(input_field, extract_value(expected_record, expected_name))
      end
      count += 1
    end
  end
  
  def extract_value(expected_record, ebay_item_field_name)
    if ebay_item_field_name.is_a? Array
      ebay_item_value = ebay_item_field_name[1].call(expected_record[ebay_item_field_name[0]])
    else
      ebay_item_value = expected_record[ebay_item_field_name]
    end
    ebay_item_value
  end


  def check_ebay_item_and_data(ebay_item, stored_item)
    assert_equal ebay_item.description, stored_item.description
    assert_equal ebay_item.itemid, stored_item.itemid
    assert_equal ebay_item.endtime, stored_item.endtime
    assert_equal ebay_item.starttime, stored_item.starttime
    assert_equal ebay_item.galleryimg, stored_item.galleryimg
    assert_equal ebay_item.bidcount, stored_item.bidcount
    assert_equal ebay_item.price, stored_item.price
    assert_equal ebay_item.sellerid, stored_item.sellerid
  end

end