class RecordsViewTest <  ActionController::TestCase

  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']
  RECORD_INPUT_TYPE_FIELDS = Array.new(RECORD_DISPLAY_FIELDS);
  RECORD_INPUT_TYPE_FIELDS.delete('date')
  
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
              begin
                actual_value = Date.parse(actual_value)
              rescue ArgumentError
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

  def check_record_fields selector_path, record_input_type_fields, assertions
    count = 0
    assert_select selector_path do |input_fields|
      assert_equal input_fields.length, record_input_type_fields.length      
      input_fields.each do |input_field|
        expected_name = record_input_type_fields[count]
        assertions.each do |assertion|
          assertion.call(input_field, expected_name)
        end
        count += 1
      end
    end
  end

end