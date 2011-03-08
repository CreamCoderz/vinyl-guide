require 'spec_helper'

describe ReleasesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "releases", :action => "index").should == "/releases"
    end

    it "maps #new" do
      route_for(:controller => "releases", :action => "new").should == "/releases/new"
    end

    it "maps #show" do
      route_for(:controller => "releases", :action => "show", :id => "1").should == "/releases/1"
    end

    it "maps #edit" do
      route_for(:controller => "releases", :action => "edit", :id => "1").should == "/releases/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "releases", :action => "create").should == {:path => "/releases", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "releases", :action => "update", :id => "1").should == {:path =>"/releases/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "releases", :action => "destroy", :id => "1").should == {:path =>"/releases/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/releases").should == {:controller => "releases", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/releases/new").should == {:controller => "releases", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/releases").should == {:controller => "releases", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/releases/1").should == {:controller => "releases", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/releases/1/edit").should == {:controller => "releases", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/releases/1").should == {:controller => "releases", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/releases/1").should == {:controller => "releases", :action => "destroy", :id => "1"}
    end
  end
end
