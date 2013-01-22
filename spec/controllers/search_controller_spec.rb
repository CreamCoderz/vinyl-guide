require 'spec_helper'

describe SearchController do

  ENDTIME, PRICE, TITLE = SearchController::SORTABLE_OPTIONS
  DESC, ASC = SearchController::ORDER_OPTIONS


  describe "#search" do

    context "default search" do
      before do
        @mock_search = mock("search")
        @mock_search.stub(:execute).and_return(@mock_search)
        @paginated_collection = WillPaginate::Collection.create(1, 1, 0) do |pager|
          pager.replace([])
        end
        @mock_search.stub(:total).any_number_of_times.and_return(0)
        @mock_search.stub(:results).any_number_of_times.and_return(@paginated_collection)
      end

      it "uses the default search params" do
        expect_search_params(@mock_search, {:keywords => 'Dub Crisis', :order_by => [:endtime, :desc],
                                            :paginate => [:page => 1, :per_page => 20]})
        get :search, {:q => "Dub Crisis"}
      end

      it "uses the order params" do
        expect_search_params(@mock_search, {:keywords => 'Dub Crisis', :order_by => [:price, :asc],
                                            :paginate => [:page => 1, :per_page => 20]})
        get :search, {:q => "Dub Crisis", :order => 'asc', :sort => 'price'}
      end

      it "uses the page param" do
        expect_search_params(@mock_search, {:keywords => 'Dub Crisis', :order_by => [:endtime, :desc],
                                            :paginate => [:page => 5, :per_page => 20]})
        get :search, {:q => "Dub Crisis", :page => 5}
      end

      it "uses the mapped only param" do
        expect_search_params(@mock_search, {:keywords => 'Dub Crisis', :order_by => [:endtime, :desc],
                                            :paginate => [:page => 1, :per_page => 20], :with => [:mapped, true]})
        get :search, {:q => "Dub Crisis", :include_mapped => "true"}
      end

      it "ignores a blank query" do
        EbayItem.should_not_receive(:search)
        get :search, {:q => ""}
      end

      it "resques from connection exceptions" do
        EbayItem.stub(:search).and_raise(Errno::ECONNREFUSED)
        get :search, {:q => "exception raising query"}
      end
    end

    context "ajaxy search" do
      before do
        @ebay_item = Factory(:ebay_item, :title => 'meditations')

        @mock_search = mock("search")
        @mock_search.should_receive(:execute).and_return(@mock_search)

        @paginated_collection = WillPaginate::Collection.create(1, 1, 1) do |pager|
          pager.replace([@ebay_item])
        end
        @mock_search.should_receive(:total).any_number_of_times.and_return(1)
        @mock_search.should_receive(:results).any_number_of_times.and_return(@paginated_collection)
      end
      it "render json results" do
        expect_search_params(@mock_search, {:keywords => 'meditations', :order_by => [:endtime, :desc],
                                            :paginate => [:page => 1, :per_page => 20]})
        response = xhr :get, :search, :q => 'meditations'
        body = JSON.parse(response.body)
        body['hits'].should == 1
        body['ebay_items'].should == JSON.parse([@ebay_item].to_json(:only => [:title, :id], :methods => [:link]))
      end
    end

    def expect_search_params(mock_search, params={})
      Sunspot.session.should_receive(:new_search).with(EbayItem).once.and_yield do |context|
        params.each_pair { |key, value| context.should_receive(key).with(*value) }
      end.and_return(mock_search)
    end
  end

end
