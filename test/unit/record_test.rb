require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  def test_create_new_record
    record = Record.new 
    assert !record.save, "should not be able to save with no name"
    record.title = "The Heart of the Congos"
    assert record.save
  end
end
