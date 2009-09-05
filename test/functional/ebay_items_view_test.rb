require 'test_helper'
include BaseTestCase

class EbayItemsViewTest <  ActionController::TestCase

  def setup
    @controller = EbayItemsController.new
  end

  #TODO: clean this up

  def check_view_fields(expected_fields, expected_items)
    item_count = 0
    count = 0
    assert_select 'li' do |ebay_items|
      ebay_items.each do |ebay_item|
        expected_record = expected_items[item_count]
        assert_select ebay_item, 'p span' do |item_field|
          item_field.each do |item_value|
            ebay_item_field_name = expected_fields[count]
            expected_value = extract_value(expected_record, ebay_item_field_name)
            if count < EBAY_ITEM_DISPLAY_FIELDS.length
              actual_value = item_value.children.to_s
              assert_equal expected_value, actual_value
              count += 1
            end
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

end