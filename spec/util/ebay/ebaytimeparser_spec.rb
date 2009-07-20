require 'spec'
require 'activesupport'
require 'time'
require File.dirname(__FILE__) + "/../../base_spec_case"
require File.dirname(__FILE__) + "/../../../app/util/dateutil"
require File.dirname(__FILE__) + '/../../../app/util/ebay/ebaytimeparser'


describe EbayTimeParser do

  it 'should parse the current ebay time into a Date' do
    current_time = EbayTimeParser.parse(BaseSpecCase::SAMPLE_GET_EBAY_TIME_RESPONSE)
    current_time.should == DateUtil.utc_to_date(BaseSpecCase::CURRENT_EBAY_TIME)
  end

end