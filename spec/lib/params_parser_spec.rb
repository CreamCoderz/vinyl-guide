require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + "/../../lib/params_parser"

describe ParamsParser do

  describe "#parse_sort_params" do
    describe "the time param" do
      ['today', 'week', 'month', 'all'].each do |time|
        it "parses #{time}" do
          params = {:time => time}
          ParamsParser.parse_sort_params(params).time.should == time          
        end
      end

      it "defaults to all" do
        params = {}
        ParamsParser.parse_sort_params(params).time.should == 'all'
      end
    end
  end
end