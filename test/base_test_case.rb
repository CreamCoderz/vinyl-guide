module BaseTestCase
  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']
  DISPLAY_AS_LINK = lambda {|href| "<a href=\"" + href + "\">" + href + "</a>"}
  DISPLAY_AS_IMG = lambda do |src|
    if src.nil?
      DEFAULT_IMG_URL
    else
      "<img src=\"#{src}\" />"
    end
  end
  DISPLAY_PICTURE = lambda do |pictures|
    if pictures
      pictures_html = ""
      pictures.each do |picture|
        pictures_html += "<p><img src=\"#{picture.url}\" /></p>"
      end
      pictures_html.empty? ? nil : pictures_html
    end
    nil
  end
  DEFAULT_IMG_URL = '<img src="/images/noimage.jpg" />'
  ESCAPE_HTML = lambda {|html| CGI.escapeHTML(html)}
  TO_S = lambda {|arg| arg.to_s}
  TO_DATE = lambda {|arg| arg.to_time.strftime("%Y-%m-%d %H:%M:%S UTC")}
  TO_DOLLARS = lambda {|arg| "$#{arg.to_s}0"}

  EBAY_ITEM_DISPLAY_FIELDS = [['itemid', TO_S], ['title', TO_S], ['description', ESCAPE_HTML], ['bidcount', TO_S], ['price', TO_DOLLARS], ['endtime', TO_DATE], ['starttime', TO_DATE], ['url', DISPLAY_AS_LINK], ['galleryimg', DISPLAY_AS_IMG], ['sellerid', TO_S]]
  EBAY_ITEM_ABBRV_DISPLAY_FIELDS = [['galleryimg', DISPLAY_AS_IMG], ['title', TO_S], ['endtime', TO_DATE], ['price', TO_DOLLARS]]

  RECORD_INPUT_TYPE_FIELDS = Array.new(RECORD_DISPLAY_FIELDS);
  RECORD_INPUT_TYPE_FIELDS.delete('date')

  RECORD_SEARCHABLE_FIELDS = ['artist', 'name', 'description', 'producer', 'band', 'engineer', 'studio'];

  def check_record_fields selector_path, record_input_type_fields, assertions, expected_record=nil
    assert_select selector_path do |input_fields|
      check_record_field(assertions, input_fields, record_input_type_fields, expected_record)
    end
  end

  def check_search_results(expected_records)
    assert_select '.abbrvItem' do |ebay_nodes|
      count = 0
      ebay_nodes.each do |ebay_item|
        assert_select ebay_item, 'p span' do |item_fields|
          expected_record = expected_records[count]
          check_record_field_with_extraction [Proc.new {|field, expected_value| assert_equal expected_value, field.children.to_s}],
                  item_fields, EBAY_ITEM_ABBRV_DISPLAY_FIELDS, expected_record
          count += 1
        end
      end
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
    assert_equal ebay_item.title, stored_item.title
    assert_equal ebay_item.description, stored_item.description
    assert_equal ebay_item.itemid, stored_item.itemid
    assert_equal ebay_item.endtime, stored_item.endtime
    assert_equal ebay_item.starttime, stored_item.starttime
    assert_equal ebay_item.galleryimg, stored_item.galleryimg
    assert_equal ebay_item.bidcount, stored_item.bidcount
    assert_equal ebay_item.price, stored_item.price
    assert_equal ebay_item.sellerid, stored_item.sellerid
    count = 0
    assert_equal ebay_item.pictureimgs.length, stored_item.pictures.length
    ebay_item.pictureimgs.each do |pictureimg|
      picture = stored_item.pictures[count]
      assert_equal pictureimg, picture.url
      assert_equal stored_item.id, picture.ebay_item_id
      count += 1
    end
  end

  def generate_some_ebay_items(num)
    ebay_items = []
    (1..num).each do |i|
      ebay_item = EbayItem.new(:itemid => BaseSpecCase::TETRACK_EBAY_ITEM.itemid + i, :title => BaseSpecCase::TETRACK_EBAY_ITEM.title, :description => CGI.unescapeHTML(BaseSpecCase::TETRACK_EBAY_ITEM.description), :bidcount => BaseSpecCase::TETRACK_EBAY_ITEM.bidcount,
              :price => BaseSpecCase::TETRACK_EBAY_ITEM.price, :endtime => BaseSpecCase::TETRACK_EBAY_ITEM.endtime, :starttime => BaseSpecCase::TETRACK_EBAY_ITEM.starttime,
              :url => BaseSpecCase::TETRACK_EBAY_ITEM.url, :galleryimg => BaseSpecCase::TETRACK_EBAY_ITEM.galleryimg, :sellerid => BaseSpecCase::TETRACK_EBAY_ITEM.sellerid)
      ebay_items.insert(-1, ebay_item)
      ebay_item.save
    end
    ebay_items
  end
end