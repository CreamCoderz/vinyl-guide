require 'spec_helper'

describe UsersController do
  before do
    @user = Factory(:confirmed_user)
  end
  describe "#show" do
    context "success" do
      before do
        sign_in @user
      end
      it "assigns user" do
        get :show, :id => @user.id
        assigns[:user].should == @user
      end
      it "assigns the first three favorites" do
        @favorite = Factory(:favorite, :user => @user)
        get :show, :id => @user.id
        assigns[:favorites].should include(@favorite)
      end
      it "assigns the first three comments" do
        @comment = Factory(:comment, :user => @user)
        get :show, :id => @user.id
        assigns[:comments].should include(@comment)
      end
    end

    context "failure" do
      it "returns a 401 for an unauthorized user" do
        sign_in @user
        get :show, :id => Factory(:confirmed_user).id
        response.status.should == 403
      end
    end
  end
end