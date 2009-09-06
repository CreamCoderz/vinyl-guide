require 'test_helper'
File.expand_path(File.dirname(__FILE__) + "/ebay_items_controller_test")

include BaseTestCase

class EbayItemsViewTest <  ActionController::TestCase

  def setup
    @controller = EbayItemsController.new
  end

  #TODO: clean this up
  #TODO: more importantly.. this method is generating some
  #TODO: nil expectations and nil data.. it is largely ignoring dates.. what's goin on here?

  def check_view_fields(expected_fields, expected_items)
    item_count = 0
    assert_select 'li' do |ebay_items|
      ebay_items.each do |ebay_item|
        puts 'each'
        expected_record = expected_items[item_count]
        count = 0
        assert_select ebay_item, 'li.recordItem p span' do |item_field|
          item_field.each do |item_value|
            puts 'count' + count.to_s
            ebay_item_field_name = expected_fields[count]
            expected_value = extract_value(expected_record, ebay_item_field_name)
            actual_value = item_value.children.to_s
            puts 'actual_val: ' + actual_value.to_s
            puts 'expected_val: ' + expected_value.to_s
            assert_equal expected_value, CGI.unescapeHTML(actual_value), "field \"#{ebay_item_field_name[0]}\""
            count += 1
          end
          count = 0
        end
        item_count += 1
      end
    end
  end

  def test_index_view
    get :index
    sorted_ebay_items = EbayItem.find(:all, :order => "endtime").reverse
    assert_select "h3", "#{sorted_ebay_items.length} Latest Vinyl Results"
    check_view_fields(EBAY_ITEM_ABBRV_DISPLAY_FIELDS, sorted_ebay_items)
    count = 0
    assert_select "a.view" do |view_anchors|
      view_anchors.each do |view_anchor|
        assert_equal "/#{sorted_ebay_items[count].id}", view_anchor.attributes['href']
        count += 1
      end
    end
  end

  def test_show_view
    get :show, :id => 1
    check_view_fields(EBAY_ITEM_DISPLAY_FIELDS, [ebay_items(:one)])
  end

  def test_all_view_base_case
    EbayItemsControllerTest.generate_some_ebay_items(25)
    get :all, :id => 1
    ebay_items = EbayItem.find(:all, :order => "endtime", :limit => EbayItemsController::PAGE_LIMIT).reverse
    #TODO: uncomment this line of coe when check_view_fields is fixed
    # check_view_fields(EBAY_ITEM_ABBRV_DISPLAY_FIELDS, ebay_items)
    assert_select ".next" do |elm|
      assert_equal "/all/#{assigns(:next)}", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "Vinyl Results #{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)}"
  end

end