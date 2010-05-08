require 'test_helper'
File.expand_path(File.dirname(__FILE__) + "/ebay_items_controller_test")

include BaseTestCase

class EbayItemsViewTest <  ActionController::TestCase
  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_FIELDS
  DESC, ASC = SearchController::ORDER_FIELDS

  def setup
    @controller = EbayItemsController.new
    @ebay_item_data_builder = EbayItemDataBuilder.new
    @ebay_items = [ebay_items(:five), ebay_items(:four), ebay_items(:three), ebay_items(:two), ebay_items(:one)]
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
    get :singles, :page => 1, :sort => ENDTIME, :order => DESC
    check_index_items(ebay_singles.reverse[0..19])

    ebay_eps =  generate_ebay_items_with_size(25, "10\"")
    save_ebay_items(ebay_eps)
    get :eps, :page => 1
    check_index_items(ebay_eps.reverse[0..19])

    ebay_lps = generate_ebay_items_with_size(25, "LP")
    save_ebay_items(ebay_lps)
    get :lps, :page => 1
    check_index_items(ebay_lps.reverse[0..19])

    other_items = generate_ebay_items_with_size(25, "something else")
    save_ebay_items(other_items)
    get :other, :page => 1
    check_index_items(other_items.reverse[0..19])
  end

  def test_pagination
    ebay_items = generate_some_ebay_items(25).reverse
    get :all, :page => 1, :sort_param => ENDTIME, :order_param => DESC
    assert_select ".next" do |elm|
      assert_equal "/all?sort=#{ENDTIME}&order=#{DESC}&page=2", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "All Vinyl Results #{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)}"
  end

  def test_show_view
    get :show, :id => 1
    check_item_result(assert_select('li p span'), ebay_items(:one), EBAY_ITEM_DISPLAY_FIELDS)
    get :show, :id => 4
    check_item_result(assert_select('li p span'), ebay_items(:four), EBAY_ITEM_DISPLAY_FIELDS)

  end

  def test_show_pictures
    get :show, :id => 1
    assert_select 'div.pictures span img' do |pictures|
      count = 0
      pictures.each do |picture|
        assert_equal "/images/pictures/#{ebay_items(:one).id}_#{count}.jpg", picture.attributes['src']
        count += 1
      end
    end
    get :show, :id => 2
    assert css_select('div.pictures').empty?
  end

  def test_no_pictures
    get :show, :id => 3
    assert css_select('div.pictures').empty?
  end

  def test_all_view_base_case
    ebay_items = @ebay_item_data_builder.make.to_many_items(25)
    ebay_items.each { |ebay_item| ebay_item.save}
    expected_ebay_items = @ebay_items.concat(ebay_items.reverse[0..14])
    response = get :all, :page => 1
    check_view_fields(EBAY_ITEM_ABBRV_DISPLAY_FIELDS, expected_ebay_items)
    assert_select ".next" do |elm|
      assert_equal "/all?sort=endtime&order=desc&page=#{assigns(:next)}", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "All Vinyl Results #{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)}"
  end

  private

  def check_view_fields(expected_fields, expected_items)
    item_count = 0
    assert_select 'li' do |ebay_items|
      ebay_items.each do |ebay_item|
        check_item_result(assert_select(ebay_item, 'li p span'), expected_items[item_count], expected_fields)
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

end