require File.dirname(__FILE__) + "/../../app/util/dateutil"
require 'ActiveSupport'

class DateUtil

  describe "it should parse a date into an iso8601 string" do
    date = Date.new(2009, 07, 10)
    DateUtil.date_to_utc(date).should == '2009-07-10T00:00:00.000Z'
  end

  describe "it should parse a string in iso8601 format to a date" do
    date = DateUtil.utc_to_date('2009-07-11T00:00:00.000Z')
    date.should == Date.new(2009, 07, 11)
  end
end