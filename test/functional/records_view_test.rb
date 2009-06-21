require 'test_helper'
include BaseTestCase

class RecordsViewTest <  ActionController::TestCase

  def setup
    @controller = RecordsController.new
  end

  #TODO: test date fields

  def test_edit_view
    expected_record = records(:one)
    get :edit, :id => expected_record.to_param
    check_record_fields 'form p input[type=text]', RECORD_INPUT_TYPE_FIELDS,
            [Proc.new {|field, expected_value| assert_select field, '[name=?]', 'record[' + expected_value + ']'},
                    Proc.new {|field, expected_value| assert_select field, '[value=?]', expected_record[expected_value]}]
  end

  #TODO: test date fields

  def test_create_view
    get :new
    check_record_fields 'form p input[type=text]', RECORD_INPUT_TYPE_FIELDS,
            [Proc.new {|field, expected_value| assert_select field, '[name=?]', 'record[' + expected_value + ']'}]
  end

  def test_show_view
    expected_record = records(:one)
    get :show, :id => expected_record.to_param
    check_record_fields 'div.recordData p span', RECORD_DISPLAY_FIELDS,
            [Proc.new {|field, expected_value| assert_equal field.children.to_s, expected_record[expected_value].to_s}]
  end

  def test_should_diplay_search_form
    get :index
    assert_select 'form[name=search]' do |search_form|
      search_form_attributes = search_form[0].attributes
      assert_equal search_form_attributes['action'], '/search'
      assert_equal search_form_attributes['method'], 'get'
      assert_select 'input' do |input_field|
        input_field_attributes = input_field[0].attributes
        assert_equal input_field_attributes['name'], 'query'
        input_field_attributes = input_field[1].attributes
        assert_equal input_field_attributes['type'], 'submit'
      end
    end
  end

  #TODO: this function is ugly so i moved it to the bottom

  def test_index_view
    get :index
    record_count = 0
    count = 0
    assert_select 'li' do |records|
      records.each do |record|
        expected_record = Record.find(record_count+1)
        assert_select record, 'p span' do |record_field|
          record_field.each do |record_value|
            expected_value = expected_record[RECORD_DISPLAY_FIELDS[count]]
            if count < RECORD_DISPLAY_FIELDS.length
              actual_value = record_value.children.to_s
              #TODO: there should be a better way to infer a Date type
              begin
                actual_value = Date.parse(actual_value)
              rescue ArgumentError
                expected_value = CGI.escapeHTML(expected_value)
              end
              assert_equal expected_value, actual_value
              count += 1
            end
          end
          count = 0
        end
        record_count += 1
      end
    end
  end



end