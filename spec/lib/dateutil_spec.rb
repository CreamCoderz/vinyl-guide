require File.dirname(__FILE__) + "/../../lib/dateutil"
require 'time'
require 'spec'

describe DateUtil do

  it "should parse a date into an iso8601 string" do
    date = DateTime.parse('2009-07-11T11:40:00+00:00')    
    DateUtil.date_to_utc(date).should == '2009-07-11T11:40:00.000Z'
  end

  it "should parse a string in iso8601 format to a date" do
    expected_time = DateTime.parse('2009-07-11T10:20:00+00:00')
    date = DateUtil.utc_to_date('2009-07-11T10:20:00.000Z')
    date.should == expected_time
  end
end