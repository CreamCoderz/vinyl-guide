require 'test_helper'
include BaseTestCase

class HeaderViewTest <  ActionController::TestCase

  TEMPLATE_PATH = File.dirname(__FILE__) + '/../../app/views/partials/_header.html.erb'

  def test_should_populate_correct_order_link
    q = "JAH"
    @sortable_base_url = "/search?q=#{q}"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "#enddate", 'END DATE'
    assert css_select(@selected, "#enddate a").empty?
    assert_select @selected, "#price a" do
      assert_select "[href=?]", "/search?q=#{q}&order=price"
    end
    @order_param = "price"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "#price", 'PRICE'
    assert_select @selected, "#enddate a" do
      assert_select "[href=?]", "/search?q=#{q}&order=enddate"
    end
  end

  #TODO: test all sortable fields SearchController::SORTABLE_FIELDS
  #TODO: test ordering is set correctly (ascending|descending)

  def test_order_link_appends_query
    q = "JAH"
    @sortable_base_url = "/search"
    @selected = bind_erb_file(TEMPLATE_PATH, self.send(:binding))
  end

end
