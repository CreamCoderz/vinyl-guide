class RecordsViewTest <  ActionController::TestCase

  RECORD_DISPLAY_FIELDS = ['artist', 'name', 'description', 'date', 'img_src', 'producer', 'band', 'engineer', 'studio']

  def setup()
    @controller = RecordsController.new
  end

  def test_index_view()
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

end