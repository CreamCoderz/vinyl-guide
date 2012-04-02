require 'spec_helper'

describe SessionsController do
  before do
    @referer = "/all"
  end

  describe "#new" do
    before do
      request.env["HTTP_REFERER"] = @referer
    end
    #TODO:fix this test
    #it "sets the flash notice to the message query param" do
    #  message = "Please sign in to add an item to your favorites."
    #  get :new, :message => message
    #  flash[:notice].should == message
    #end
    #it "assigns @redirect_url from the referer" do
    #  get :new
    #  assigns[:redirect_url].should == @referer
    #end
  end

  describe "#after_sign_in_path_for" do
    it "returns the redirect_url param" do
      controller.params.should_receive(:[]).with(:redirect_url).and_return(@referer)
      controller.after_sign_in_path_for(User).should == @referer
    end
    it "returns the root_path by default" do
      controller.after_sign_in_path_for(User).should == root_path
    end
  end
end