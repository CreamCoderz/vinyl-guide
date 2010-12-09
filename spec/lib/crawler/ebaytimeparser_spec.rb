require 'spec'
require 'time'
require File.dirname(__FILE__) + "/ebay_base_data"
require File.dirname(__FILE__) + "/../../../lib/dateutil"
require File.dirname(__FILE__) + '/../../../lib/crawler/ebaytimeparser'
include EbayBaseData


describe EbayTimeParser do

  it 'should parse the current ebay time into a Date' do
    current_time = EbayTimeParser.parse(SAMPLE_GET_EBAY_TIME_RESPONSE)
    current_time.should == DateUtil.utc_to_date(CURRENT_EBAY_TIME)
  end

end