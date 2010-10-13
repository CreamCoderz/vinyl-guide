require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../../lib/paginator/util'
require File.dirname(__FILE__) + '/../../../test/base_test_case'
include BaseTestCase

describe Paginator::Util do

  describe "#paginate" do
    before do
      @paginator = Paginator::Util.new(EbayItem)
    end
    context "ebay items exist" do
      before do
        30.times { Factory(:ebay_item) }
      end

      it "should paginate for page 1" do
        paginated_result = @paginator.paginate(1)
        paginated_result.items.should == EbayItem.all(:order => "id DESC", :limit => 20)
        paginated_result.prev_page_num.should be_nil
        paginated_result.next_page_num.should == 2
        paginated_result.start_from.should == 1
        paginated_result.end_on.should == 20
        paginated_result.total.should == 30
      end

      it "paginates for page 2" do
        paginated_result = @paginator.paginate(2)
        paginated_result.items.should == EbayItem.all(:order => "id DESC", :limit => 10, :offset => 20)
        paginated_result.prev_page_num.should == 1
        paginated_result.next_page_num.should be_nil
        paginated_result.start_from.should == 21
        paginated_result.end_on.should == 30
      end

      it "paginates for page 2 with more items" do
        10.times { Factory(:ebay_item) }
        paginated_result = @paginator.paginate(2)
        paginated_result.next_page_num.should be_nil
        paginated_result.prev_page_num.should == 1
        paginated_result.start_from.should == 21
        paginated_result.end_on.should == 40
        paginated_result.total.should == 40
      end
    end

    describe "#empty?" do
      it "has empty results" do
        paginated_result = @paginator.paginate(1)
        paginated_result.should be_empty
        paginated_result.items.should be_empty
        paginated_result.prev_page_num.should be_nil
        paginated_result.next_page_num.should be_nil
        paginated_result.start_from.should be_nil
        paginated_result.end_on.should be_nil
        paginated_result.total.should == 0
      end

      it "has results" do
        Factory(:ebay_item)
        @paginator.paginate(1).should_not be_empty
      end

      it "should handle a page out of range" do
        @paginator.paginate(2).should be_empty
        @paginator.paginate(3).should be_empty
        @paginator.paginate(0).should be_empty
      end
    end
  end

  def check_empty_results(paginated_result)

  end

end