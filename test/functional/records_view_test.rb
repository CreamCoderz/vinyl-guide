class RecordsViewTest <  ActionController::TestCase

  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']

  def setup
    @controller = RecordsController.new
  end

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

  #TODO: test date fields
  def test_edit_view
    record_input_type_fields = Array.new(RECORD_DISPLAY_FIELDS)
    record_input_type_fields.delete('date')
    get :edit, :id => records(:one).to_param
    field_count = 0
    count = 0
    assert_select 'form p input[type=text]' do |input_fields|
      input_fields.each do |input_field|
        puts input_field
        puts 'count ' + count.to_s
        puts 'expected ' + record_input_type_fields[count]
        expected_name = record_input_type_fields[count]
        assert_select input_field, '[name=?]', 'record[' + expected_name + ']'
        count += 1
      end
      puts input_fields.length
    end
  end
end