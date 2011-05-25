require 'spec_helper'
require 'time'
require File.dirname(__FILE__) + "/ebay_base_data"
require File.dirname(__FILE__) + "/../../../lib/date_util"
require File.dirname(__FILE__) + '/../../../lib/crawler/ebay_time_parser'
include EbayBaseData


describe EbayTimeParser do

  it 'should parse the current ebay time into a Date' do
    current_time = EbayTimeParser.parse(SAMPLE_GET_EBAY_TIME_RESPONSE)
    current_time.should == DateUtil.utc_to_date(CURRENT_EBAY_TIME)
  end

end