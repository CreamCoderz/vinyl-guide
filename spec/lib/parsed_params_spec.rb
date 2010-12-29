require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + "/../../lib/parsed_params"

describe ParsedParams do

  describe "#parse_sort_params" do
    describe "the time param" do
      ['today', 'week', 'month', 'all_time'].each do |time|
        it "parses #{time}" do
          params = {:time => time}
          ParamsParser.parse_sort_params(params).time.should == time
        end
      end

      it "defaults to all" do
        params = {}
        ParamsParser.parse_sort_params(params).time.should == 'all_time'
      end

    end
  end

  describe "acceptable params" do
    it "accepts q" do
      parsed_params = ParamsParser.parse_sort_params({:q => "foo"})
      parsed_params.q.should == "foo"
      parsed_params.declared?(:q).should be_true
    end
  end

  describe "#selected?" do
    before do
      @parsed_params = ParsedParams.new({:order => "desc"})
    end
    it "returns true" do
      @parsed_params.selected?(:order, "desc").should be_true
    end
    it "returns false" do
      @parsed_params.selected?(:time, "desc").should be_false
    end
    it "defaults to endtime" do
      parsed_params = ParamsParser.parse_sort_params({})
      parsed_params.selected?(:sort, 'endtime').should be_true
    end
    context "accepted param is set" do
      it "defaults to endtime when accepted_param is set" do
        parsed_params = ParamsParser.parse_sort_params({:q => "junior murvin"})
        parsed_params.selected?(:sort, 'endtime').should be_true
      end
      it "defaults to endtime when accepted_param is set" do
        parsed_params = ParamsParser.parse_sort_params({:q => "junior murvin", :sort => "price"})
        parsed_params.selected?(:sort, 'endtime').should be_false
        parsed_params.selected?(:sort, 'price').should be_true
      end
    end
  end

  describe "#declared?" do
    before do
      @parsed_params = ParsedParams.new({:order => "desc"})
    end
    it "returns true" do
      @parsed_params.declared?(:order).should be_true
    end
    it "returns false" do
      @parsed_params.declared?(:time).should be_false
    end
  end

  describe "#selected" do
    before do
      @parsed_params = ParsedParams.new({:sort => "price", :order => "desc"})
    end
    it "returns a hash of declared params" do
      @parsed_params.selected.should == {:sort => "price", :order => "desc"}
    end
    it "clones the params hash to avoid modification" do
      query_params = @parsed_params.selected
      query_params.should == {:sort => "price", :order => "desc"}
      query_params[:foo] = "bar"
      @parsed_params.selected[:foo].should be_nil
    end
  end

  describe "#[]" do
    it "returns params via key" do
      parsed_params = ParamsParser.parse_sort_params(:sort => 'endtime')
      parsed_params[:sort].should == 'endtime'
    end
  end
end