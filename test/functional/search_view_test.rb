require 'test_helper'
include BaseTestCase

class SearchViewTest <  ActionController::TestCase
  PRINCE = 'prince'
  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_OPTIONS
  DESC, ASC = SearchController::ORDER_OPTIONS

  def setup
    @controller = SearchController.new
  end

  def test_should_display_search_view
    expected_records = [ebay_items(:four)]
    response = get :search, :q => PRINCE
    assert_response :success
    check_search_results(expected_records)
  end

  def test_pagination
    ebay_items = generate_some_ebay_items(25).reverse
    query = ebay_items[0].title
    get :search, :q => query, :sort => ENDTIME, :order => DESC
    check_search_results(ebay_items[0..19])
    assert_select ".next" do |elm|
      assert_equal "/search?q=#{CGI.escape(query)}&sort=#{ENDTIME}&order=#{DESC}&page=#{assigns(:next)}", elm[0].attributes['href']
    end
    assert css_select(".prev").empty?
    assert_select "h3", "#{assigns(:start)}-#{assigns(:end)} of #{assigns(:total)} Search Results found for #{CGI.escapeHTML("\"" + query +"\"")}"
  end

  def test_should_display_header_data
    get :search, :q => PRINCE
    assert_select 'h3', CGI.escapeHTML('1-1 of 1 Search Results found for "' + PRINCE + '"')
  end

  #TODO: this test will fail when i fix the "results 1-0 of 0" bug

  def test_input_is_html_escaped
    html_query = '<font color="red">test</font>'
    get :search, :q => html_query
    assert_select 'h3', "0 Search Results found for #{CGI.escapeHTML("\"" + html_query + "\"")}"
  end

end