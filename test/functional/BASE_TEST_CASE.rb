module RECORD_FIELD_DATA
  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']

  RECORD_INPUT_TYPE_FIELDS = Array.new(RECORD_DISPLAY_FIELDS);
  RECORD_INPUT_TYPE_FIELDS.delete('date')

  RECORD_SEARCHABLE_FIELDS = Array.new('artist', 'name', 'description', 'producer', 'band', 'engineer', 'studio');

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