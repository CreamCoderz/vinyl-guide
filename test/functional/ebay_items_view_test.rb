require 'test_helper'
include BaseTestCase

class EbayItemsViewTest <  ActionController::TestCase

  def setup
    @controller = EbayItemsController.new
  end

  #TODO: clean this up
  def test_index_view
    get :index
    item_count = 0
    count = 0
    assert_select 'li' do |ebay_items|
      ebay_items.each do |ebay_item|
        expected_record = EbayItem.find(item_count+1)
        assert_select ebay_item, 'p span' do |item_field|
          item_field.each do |item_value|
            ebay_item_field_name = EBAY_ITEM_DISPLAY_FIELDS[count]
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

end