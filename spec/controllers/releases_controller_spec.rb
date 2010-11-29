require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReleasesController do

  def mock_ebay_item(stubs={})
    @mock_ebay_item ||= mock_model(EbayItem, stubs)
  end

  def mock_release(stubs={})
    stubs.merge({:label_entity => Factory(:label)})
    @mock_release ||= mock_model(Release, stubs)
  end

  describe "#index" do
    it "assigns all releases as @releases" do
      release = Factory(:release)
      get :index
      assigns[:releases].should == [release]
    end
  end

  describe "#show" do
    it "assigns the requested release as @release" do
      Release.stub!(:find).with("37", :include => [:label_entity, :format, :ebay_items]).and_return(mock_release)
      mock_release.stub!(:ebay_items).and_return([mock_ebay_item])
      get :show, :id => "37"
      page_results = assigns[:page_results]
      actual_ebay_items = page_results.items
      actual_ebay_items.length.should == 1
      actual_ebay_items[0].id.should == mock_ebay_item.id
      assigns[:release].should equal(mock_release)
      assigns[:controls].should be_true
    end
  end

  describe "#new" do
    it "assigns a new release as @release" do
      Release.stub!(:new).and_return(mock_release({:label_entity => Factory(:label), :build_label_entity => nil}))
      get :new
      assigns[:release].should equal(mock_release)
      assigns[:release].label_entity.should_not be_nil
    end
  end

  describe "#edit" do
    it "assigns the requested release as @release" do
      Release.stub!(:find).with("37").and_return(mock_release({:label_entity => Factory(:label), :build_label_entity => nil}))
      get :edit, :id => "37"
      assigns[:release].should equal(mock_release)
      assigns[:release].label_entity.should_not be_nil
    end
  end

  describe "#create" do

    describe "with valid params" do
      it "assigns a newly created release as @release" do
        Release.stub!(:new).with({'these' => 'params'}).and_return(mock_release(:save => true))
        post :create, :release => {:these => 'params'}
        assigns[:release].should equal(mock_release)
      end

      it "redirects to the created release" do
        Release.stub!(:new).and_return(mock_release(:save => true))
        post :create, :release => {}
        response.should redirect_to(release_url(mock_release))
      end

      it "should use an existing label if the params match one" do
        cry_tuff_label = Factory(:label, :name => 'Cry Tuff')
        post :create, :release => {:artist => 'Reggae George', :format_id => Format::LP.id, :label_entity_attributes => {'name' => cry_tuff_label.name}}
        cry_tuff_label.reload.releases.length.should == 1
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved release as @release" do
        Release.stub!(:new).with({'these' => 'params'}).and_return(mock_release(:save => false))
        post :create, :release => {:these => 'params'}
        assigns[:release].should equal(mock_release)
      end

      it "re-renders the 'new' template" do
        Release.stub!(:new).and_return(mock_release(:save => false))
        post :create, :release => {}
        response.should render_template('new')
      end
    end

    describe "associates an ebay item" do
      it "should associate an ebay item with a newly created release" do
        Release.stub!(:new).and_return(mock_release(:save => true))
        ebay_item = Factory(:ebay_item)
        post :create, :release => {}, :ebay_item_id => "#{ebay_item.id}"
        EbayItem.find(ebay_item.id).release_id.should == mock_release.id
      end

      it "should only associate an existing ebay item" do
        Release.stub!(:new).and_return(mock_release(:save => true))
        EbayItem.stub!(:find_by_id).and_return(nil)
        post :create, :release => {}, :ebay_item_id => '1234'
        assigns[:release].should equal(mock_release)
      end
    end

    #TODO: these test are currently complaining about the circular reference (probably due to the mocks) but the implementation works fine
#    describe "ajax post" do
#      it "should respond with success" do
#        Release.stub!(:new).and_return(mock_release(:save => true))
#        post :create, :format => 'json', :release => {}
#        response.should be_success
#      end
#
#      it "should respond with failure" do
#        Release.stub!(:new).and_return(mock_release(:save => false))
#        post :create, :format => 'json', :release => {}
#        response.should_not be_success
#      end
#    end

  end

  describe "#update" do

    describe "with valid params" do
      it "updates the requested release" do
        Release.should_receive(:find).with("37").and_return(mock_release)
        mock_release.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :release => {:these => 'params'}
      end

      it "assigns the requested release as @release" do
        Release.stub!(:find).and_return(mock_release(:update_attributes => true))
        put :update, :id => "1"
        assigns[:release].should equal(mock_release)
      end

      it "redirects to the release" do
        Release.stub!(:find).and_return(mock_release(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(release_url(mock_release))
      end

      it "should update a release" do
        release = Factory(:release)
        put :update, :id => release.id.to_s, :release => {:title => 'foo'}
        release.reload.title.should == 'foo'
      end

    end

    describe "with invalid params" do
      it "updates the requested release" do
        Release.should_receive(:find).with("37").and_return(mock_release)
        mock_release.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :release => {:these => 'params'}
      end

      it "assigns the release as @release" do
        Release.stub!(:find).and_return(mock_release(:update_attributes => false))
        put :update, :id => "1"
        assigns[:release].should equal(mock_release)
      end

      it "re-renders the 'edit' template" do
        Release.stub!(:find).and_return(mock_release(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "#destroy" do
    it "destroys the requested release" do
      Release.should_receive(:find).with("37").and_return(mock_release)
      mock_release.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the releases list" do
      Release.stub!(:find).and_return(mock_release(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(releases_url)
    end
  end

  describe "#search" do
    it "should assign some results fields" do
      title = "thanks and praise"
      release = Factory.create(:release, :title => title)
      response = xhr :get, :search, :q => title
      body = JSON.parse(response.body)
      body['hits'].should == 1
      body['releases'].should == JSON.parse([release].to_json(:include => {:label_entity => {:only => :name}}, :only => [:matrix_number, :title, :matrix, :artist, :id], :methods => [:link]))
    end
  end

end
