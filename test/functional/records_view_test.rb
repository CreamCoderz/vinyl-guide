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


  def test_index_view
    get :index
    record_count = 1
    count = 0
    assert_select 'li' do |records|
      records.each do |record|
        check_record_display(count, record, record_count)
        record_count += 1
      end
    end
  end


  def check_record_display(count, record, record_id)
    expected_record = Record.find(record_id)
    assert_select record, 'p span' do |record_field|
      record_field.each do |record_value|
        expected_value = expected_record[RECORD_DISPLAY_FIELDS[count]]
        if count < RECORD_DISPLAY_FIELDS.length
          actual_value = record_value.children.to_s
          if expected_value.kind_of?(Date)
            actual_value = Date.parse(actual_value)
          else
            expected_value = CGI.escapeHTML(expected_value)
          end
          assert_equal expected_value, actual_value
          count += 1
        end
      end
      count = 0
    end
  end

end