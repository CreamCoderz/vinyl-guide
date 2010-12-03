require 'test_helper'
include BaseTestCase
include ApplicationHelper
include ERB::Util
include ActionController::UrlWriter

class HeaderViewTest <  ActionController::TestCase

  TEMPLATE_PATH = File.dirname(__FILE__) + '/../../app/views/partials/_header.html.erb'
  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_OPTIONS
  DESC, ASC = SearchController::ORDER_OPTIONS
  SORT_PARAM = 'sort'
  ORDER_PARAM = 'order'
  Q = "JAH"

  def test_sort_links_endtime
    @sort_param = ENDTIME
    @order_param = DESC
    @sortable_base_url = "/search?q=#{Q}"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{ENDTIME} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{ENDTIME}&amp;#{ORDER_PARAM}=#{ASC}"
      assert_select ".asc"
      assert_select ".selected"
    end
    assert_select @selected, "##{PRICE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{PRICE}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end
    assert_select @selected, "##{TITLE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{TITLE}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end

    @order_param = ASC
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{ENDTIME} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{ENDTIME}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert_select ".selected"
    end
  end

  def test_sort_links_price
    @sort_param = PRICE
    @order_param = DESC
    @sortable_base_url = "/search?q=#{Q}"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{PRICE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{PRICE}&amp;#{ORDER_PARAM}=#{ASC}"
      assert_select ".asc"
      assert_select ".selected"
    end
    assert_select @selected, "##{ENDTIME} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{ENDTIME}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end
    assert_select @selected, "##{TITLE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{TITLE}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end

    @order_param = ASC
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{PRICE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{PRICE}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert_select ".selected"
    end
  end

  def test_sort_links_title
    @sort_param = TITLE
    @order_param = DESC
    @sortable_base_url = "/search?q=#{Q}"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{PRICE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{PRICE}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end
    assert_select @selected, "##{ENDTIME} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{ENDTIME}&amp;#{ORDER_PARAM}=#{DESC}"
      assert_select ".desc"
      assert css_select(".selected").empty?
    end
    assert_select @selected, "##{TITLE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{TITLE}&amp;#{ORDER_PARAM}=#{ASC}"
      assert_select ".asc"
      assert_select ".selected"
    end

    @order_param = ASC
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{TITLE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}&amp;#{SORT_PARAM}=#{TITLE}&amp;#{ORDER_PARAM}=#{DESC}"
    end
  end

  def test_base_url_without_query_string
    @sort_param = TITLE
    @order_param = DESC
    @sortable_base_url = "/all"
    @selected = bind_erb_file(TEMPLATE_PATH, binding)
    assert_select @selected, "##{PRICE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}?#{SORT_PARAM}=#{PRICE}&amp;#{ORDER_PARAM}=#{DESC}"
    end
    assert_select @selected, "##{ENDTIME} a" do
      assert_select "[href=?]", "#{@sortable_base_url}?#{SORT_PARAM}=#{ENDTIME}&amp;#{ORDER_PARAM}=#{DESC}"
    end
    assert_select @selected, "##{TITLE} a" do
      assert_select "[href=?]", "#{@sortable_base_url}?#{SORT_PARAM}=#{TITLE}&amp;#{ORDER_PARAM}=#{ASC}"
    end
  end

end
