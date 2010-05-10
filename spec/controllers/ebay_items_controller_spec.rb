require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EbayItemsController do

  def mock_ebay_item(stubs={})
    @mock_ebay_item ||= mock_model(EbayItem, stubs)
  end

  def mock_release(stubs={})
    @mock_release ||= mock_model(Release, stubs)
  end

  it "should list child entities of a release" do
    Release.stub!(:find).with("1").and_return(mock_release, :ebay_items => EbayItem)
    EbayItem.stub!(:find).with(:all).and_return([mock_ebay_item])
    mock_release.should_receive(:ebay_items).and_return(EbayItem)
    get :index, :release_id => "1", :id => "1"
    actual_ebay_items = assigns[:ebay_items]
    actual_ebay_items.length.should == 1
    actual_ebay_items[0].id.should == mock_ebay_item.id
    assigns[:release].id.should == mock_release.id
  end
end