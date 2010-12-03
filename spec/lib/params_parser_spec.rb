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

  describe "#selected?" do
    before do
      @parsed_params = ParamsParser::ParsedParams.new({:order => "desc"})
    end
    it "returns true" do
      @parsed_params.selected?(:order, "desc").should be_true
    end
    it "returns false" do
      @parsed_params.selected?(:time, "desc").should be_false
    end
    it "defaults to endtime" do
      parsed_params = ParamsParser.parse_sort_params({})
      parsed_params.selected?(:sort, :endtime).should be_true
    end
  end

  describe "#declared?" do
    before do
      @parsed_params = ParamsParser::ParsedParams.new({:order => "desc"})
    end
    it "returns true" do
      @parsed_params.declared?(:order).should be_true
    end
    it "returns false" do
      @parsed_params.declared?(:time).should be_false
    end
  end

  describe "#[]" do
    it "returns params via key" do
      parsed_params = ParamsParser.parse_sort_params(:sort => 'endtime')
      parsed_params[:sort].should == 'endtime'
    end
  end
end