require 'spec_helper'

describe UsersController do

  describe "#new" do
    before do
      get :new
    end
    it "assigns user" do
      assigns[:user].should be_present
    end
  end

  describe "#create" do
    context "success scenarios" do
      before do
        post :create, :user => {:email => "will@rootsvinylguide.com", :password => "foobar"}
      end
      it "creates a new user" do
        User.find_by_email("will@rootsvinylguide.com").should be_present
      end
      it "redirects to home" do
        response.should redirect_to(root_path)
      end
    end
    context "failure scenarios" do
      before do
        post :create, :user => {:email => "will+missingpassword@rootsvinylguide.com"}
      end
      it "renders the new page with @user set" do
        response.should render_template("users/new")
      end
    end
  end

end