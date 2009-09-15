require 'test_helper'
include BaseTestCase

class SearchViewTest <  ActionController::TestCase
  PRINCE = 'prince'

  def setup
    @controller = SearchController.new
  end

  def check_search_results(expected_records)
    assert_select '.recordItem' do |ebay_nodes|
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

  def test_should_display_search_view
    expected_records = [ebay_items(:five), ebay_items(:four)]
    get :search, :query => PRINCE
    assert_response :success
    check_search_results(expected_records)
  end

  def test_pagination
    ebay_items = generate_some_ebay_items(25).reverse
    query = ebay_items[0].title
    get :search, :query => query
    check_search_results(ebay_items[0..19])
    assert_select ".next" do |elm|
      assert_equal "/search?query=#{CGI.escape(query)}&page=#{assigns(:next)}", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "#{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)} Search Results found for #{CGI.escapeHTML("\"" + query +"\"")}"
  end

  def test_should_display_header_data
    get :search, :query => PRINCE
    assert_select 'h3', CGI.escapeHTML('1-2 of 2 Search Results found for "' + PRINCE + '"')
  end

  #TODO: this test will fail when i fix the "results 1-0 of 0" bug

  def test_input_is_html_escaped
    html_query = '<font color="red">test</font>'
    get :search, :query => html_query
    assert_select 'h3', "0 Search Results found for #{CGI.escapeHTML("\"" + html_query + "\"")}"
  end

end