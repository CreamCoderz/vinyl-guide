require 'test_helper'
File.expand_path(File.dirname(__FILE__) + "/ebay_items_controller_test")

include BaseTestCase

class EbayItemsViewTest <  ActionController::TestCase

  def setup
    @controller = EbayItemsController.new
  end

  #TODO: clean this up

  def check_view_fields(expected_fields, expected_items)
    item_count = 0
    assert_select 'li' do |ebay_items|
      ebay_items.each do |ebay_item|
        expected_record = expected_items[item_count]
        count = 0
        assert_select ebay_item, 'li.recordItem p span' do |item_field|
          item_field.each do |item_value|
            ebay_item_field_name = expected_fields[count]
            expected_value = extract_value(expected_record, ebay_item_field_name)
            actual_value = item_value.children.to_s
            assert_equal expected_value, CGI.unescapeHTML(actual_value), "field \"#{ebay_item_field_name[0]}\""
            count += 1
          end
          count = 0
        end
        item_count += 1
      end
    end
  end


  def check_index_items(sorted_ebay_items)
    count = 0
    assert_select "a.view" do |view_anchors|
      view_anchors.each do |view_anchor|
        assert_equal "/#{sorted_ebay_items[count].id}", view_anchor.attributes['href']
        count += 1
      end
    end
  end

  def test_index_view
    get :index
    sorted_ebay_items = EbayItem.find(:all, :order => "endtime").reverse
    # lastest link to record displayed twice
    sorted_ebay_items.insert(0, sorted_ebay_items[0])
    check_search_results([sorted_ebay_items[0]])

    check_index_items(sorted_ebay_items)
  end

  #TODO: test pagination links are correct

  def test_specifics_index_views
    ebay_singles = generate_ebay_items_with_size(25, "7\"")
    ebay_singles.map {|ebay_item| ebay_item.save}
    get :singles, :id => 1
    check_index_items(ebay_singles.reverse[0..19])
    ebay_eps =  generate_ebay_items_with_size(25, "10\"")
    save_ebay_items(ebay_eps)
    get :eps, :id => 1
    check_index_items(ebay_eps.reverse[0..19])
    ebay_lps = generate_ebay_items_with_size(25, "LP")
    save_ebay_items(ebay_lps)
    get :lps, :id => 1
    check_index_items(ebay_lps.reverse[0..19])
    other_items = generate_ebay_items_with_size(25, "something else")
    save_ebay_items(other_items)
    get :other, :id => 1
    check_index_items(other_items.reverse[0..19])
  end

  def test_show_view
    get :show, :id => 1
    expected_ebay_item = ebay_items(:one)
    assert_select 'li p span' do |ebay_items|
      assert_equal EBAY_ITEM_DISPLAY_FIELDS.length, ebay_items.length
      count = 0
      ebay_items.each do |ebay_item|
        expected_field_name = EBAY_ITEM_DISPLAY_FIELDS[count][0]
        expected_value = expected_ebay_item[expected_field_name]
        mapping_function = EBAY_ITEM_DISPLAY_FIELDS[count][1]
        expected_extracted_value = mapping_function.call(expected_value)
        assert_equal expected_extracted_value, ebay_item.children.to_s, "error comparing expected field: '#{expected_field_name}'"
        count += 1
      end
    end
  end

  def test_show_pictures
    get :show, :id => 1
    assert_select 'div.pictures span img' do |pictures|
      count = 0
      pictures.each do |picture|
        assert_equal ebay_items(:one).pictures[count].url, picture.attributes['src']
        count += 1
      end
    end
  end

  def test_no_pictures
    get :show, :id => 2
    item_pictures = css_select 'div.pictures'
    assert item_pictures.empty?
  end

  def test_all_view_base_case
    ebay_items = generate_some_ebay_items(25).reverse[0..19]
    response = get :all, :id => 1
    check_view_fields(EBAY_ITEM_ABBRV_DISPLAY_FIELDS, ebay_items)
    assert_select ".next" do |elm|
      assert_equal "/all/#{assigns(:next)}", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "Vinyl Results #{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)}"
  end

end