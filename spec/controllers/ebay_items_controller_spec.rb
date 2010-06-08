require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EbayItemsController do

  def mock_ebay_item(stubs={})
    @mock_ebay_item ||= mock_model(EbayItem, stubs)
  end

  def mock_release(stubs={})
    @mock_release ||= mock_model(Release, stubs)
  end

  it "should list child entities of a release" do
    Release.stub!(:find).with("1", :include => :ebay_items).and_return(mock_release)
    mock_release.stub!(:ebay_items).and_return([mock_ebay_item])
    get :index, :release_id => "1", :id => "1"
    actual_ebay_items = assigns[:ebay_items]
    actual_ebay_items.length.should == 1
    actual_ebay_items[0].id.should == mock_ebay_item.id
    assigns[:release].id.should == mock_release.id
  end

  describe "GET edit" do
    it "assigns the requested ebay_item as @ebay_item" do
      EbayItem.stub!(:find).with("37").and_return(mock_ebay_item)
      get :edit, :id => "37"
      assigns[:ebay_item].should equal(mock_ebay_item)
    end
  end

  describe "PUT update" do

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