require 'spec_helper'

describe EbayItemsController do

  def mock_ebay_item(stubs={})
    @mock_ebay_item ||= mock_model(EbayItem, stubs)
  end

  describe "#home" do
    before do
      @ebay_item = Factory(:ebay_item)
    end
    it "assigns todays top three highest priced items" do
      get :home
      assigns[:top_items].should =~ [@ebay_item]
    end
  end

  describe "#index" do
    it "should list child entities of a release" do
      mock_release = mock_model(Release)
      Release.stub!(:find).with("1", :include => :ebay_items).and_return(mock_release)
      mock_release.stub!(:ebay_items).and_return([mock_ebay_item])
      get :index, :release_id => "1", :id => "1"
      actual_ebay_items = assigns[:ebay_items]
      actual_ebay_items.length.should == 1
      actual_ebay_items[0].id.should == mock_ebay_item.id
      assigns[:release].id.should == mock_release.id
    end
  end

  describe "#show" do
    before do
      @release = Factory(:release)
      @ebay_item = Factory(:ebay_item, :release => @release)
    end
    it "should assign an empty array of related ebay items" do
      get :show, :id => @ebay_item.id
      assigns[:ebay_item].should == @ebay_item
      assigns[:related_ebay_items].should be_empty
    end
    it "should assign the related ebay item" do
      related_ebay_item = Factory(:ebay_item, :release => @release)
      get :show, :id => @ebay_item.id
      assigns[:related_ebay_items].should == [related_ebay_item]
    end
  end

  describe "#edit" do
    it "assigns the requested ebay_item as @ebay_item" do
      EbayItem.stub!(:find).with("37").and_return(mock_ebay_item)
      get :edit, :id => "37"
      assigns[:ebay_item].should equal(mock_ebay_item)
    end
  end

  describe "#get" do
    it "should assign a @release" do
      get :show, :id => "#{Factory(:ebay_item).id}"
      assigns[:release].should_not be_nil
    end
  end

  context "custom routes" do
    ['lps', 'eps', 'singles', 'other'].each do |route|
      describe "##{route}" do
        before do
          @items = [Factory("#{route.singularize}_ebay_item")]
        end
        it "uses the #{route} scope to assign page_results" do
          get route.to_sym
          assigns[:page_results].items.should == @items
        end
      end
    end
  end

  describe "#update" do

    describe "with valid params" do
      it "updates the requested ebay_item" do
        EbayItem.should_receive(:find).with("37").and_return(mock_ebay_item)
        mock_ebay_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ebay_item => {:these => 'params'}
      end

      it "assigns the requested ebay_item as @ebay_item" do
        EbayItem.stub!(:find).and_return(mock_ebay_item(:update_attributes => true))
        put :update, :id => "1"
        assigns[:ebay_item].should equal(mock_ebay_item)
      end

      it "redirects to the ebay_item" do
        EbayItem.stub!(:find).and_return(mock_ebay_item(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(ebay_item_path(mock_ebay_item))
      end

      it "should return a rendered partial for an AJAX request" do
        EbayItem.stub!(:find).and_return(mock_ebay_item(:update_attributes => true))
        xhr :put, :update, :id => "1", :format => "xml", :controls => true
        response.should render_template("partials/_ebay_item_abbrv")
        assigns[:controls].should be_true
      end
    end

    describe "with invalid params" do
      it "updates the requested ebay_item" do
        EbayItem.should_receive(:find).with("37").and_return(mock_ebay_item)
        mock_ebay_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ebay_item => {:these => 'params'}
      end

      it "assigns the ebay_item as @ebay_item" do
        EbayItem.stub!(:find).and_return(mock_ebay_item(:update_attributes => false))
        put :update, :id => "1"
        assigns[:ebay_item].should equal(mock_ebay_item)
      end

      it "re-renders the 'edit' template" do
        EbayItem.stub!(:find).and_return(mock_ebay_item(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end
end