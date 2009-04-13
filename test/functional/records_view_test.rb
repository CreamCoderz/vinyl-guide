
class RecordsViewTest <  ActionController::TestCase

  RECORD_DISPLAY_FIELDS = ['name', 'description', 'date']
  
  def setup()
    @controller = RecordsController.new
  end

  def test_index_view()
    get :index
    record_count = 0
    count = 0
    assert_select 'tr' do |table_rows|
      table_rows.each do |row|
        record = Record.find(record_count+1)
        assert_select row, 'td' do |cells_in_row|
          cells_in_row.each do |cell|
            record_field_value = record[RECORD_DISPLAY_FIELDS[count]]
            if count < RECORD_DISPLAY_FIELDS.length
              cell_value = cell.children.to_s
              begin
                cell_value = Date.parse(cell_value)
              rescue ArgumentError
              end
              assert_equal record_field_value, cell_value
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