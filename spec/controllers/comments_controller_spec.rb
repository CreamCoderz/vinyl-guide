require 'spec_helper'

describe CommentsController do
  before do
    @ebay_item = Factory(:ebay_item)
    request.stub(:referrer).and_return(root_path)
  end

  describe "#create" do
    context "success" do
      before do
        @user = Factory(:confirmed_user)
        sign_in @user
        request.stub(:referrer).and_return(ebay_item_path(@ebay_item))
        post :create, :comment => {:body => "first post!", :parent_id => @ebay_item.id, :parent_type => EbayItem.to_s}
      end

      it "creates a comment" do
        Comment.find_by_body("first post!").should be_present
      end
      it "assigns the comment user_id to the logged in user" do
        Comment.find_by_body("first post!").user.should == @user
      end
      it "sets a flash notice" do
        flash[:notice].should be_present
      end
      it "responds with redirect to referrer" do
        response.should redirect_to(ebay_item_path(@ebay_item))
      end
    end

    context "failure" do
      it "redirects to sign_in page when a user is not logged in" do
        post :create, :comment => {:body => "first post!", :parent_id => @ebay_item.id, :parent_type => EbayItem.to_s}
        response.should redirect_to(new_user_session_path)
      end
      it "sets a flash message when the item cannot be saved" do
        sign_in Factory(:confirmed_user)
        post :create, :comment => {:body => "first post!"}
        flash[:error].should be_present
      end

    end
  end

  describe "#destroy" do
    before do
      @user = Factory(:confirmed_user)
      @comment = Factory(:comment, :body => 'first post', :user => @user, :parent => @ebay_item)
      request.stub(:referrer).and_return(ebay_item_path(@ebay_item))
    end
    context "success" do
      before do
        sign_in @user
        delete :destroy, :id => @comment.id
      end
      it "destroys the comment" do
        Comment.find_by_id(@comment.id).should be_nil
      end
      it "redirects to the referrer" do
        response.should redirect_to(ebay_item_path(@ebay_item))
      end
      it "sets a flash notice" do
        flash[:notice].should be_present
      end
    end
    context "failure" do
      it "only allows deletion of a user's own comment" do
        sign_in Factory(:confirmed_user)
        delete :destroy, :id => @comment.id
        flash[:error].should be_present
      end
    end
  end

  describe "#index" do
    before do
      @comment = Factory(:comment)
    end
    it "assigns @comments" do
      get :index
      assigns[:comments].should == [@comment]
    end
    it "uses page param" do
      Comment.stub(:with_recent_unique_parents).and_return(Comment)
      Comment.should_receive(:paginate).with(:page => "2", :per_page => 50).and_return([@comment])
      get :index, :page => 2
    end
    it "calls with_recent_unique_parents" do
      Comment.should_receive(:with_recent_unique_parents).and_return(Comment)
      get :index
    end
  end

  describe "#show" do
    before do
      @comment = Factory(:comment)
    end
    it "assigns @comment" do
      get :show, :id => @comment.id
      assigns[:comment].should == @comment
    end
  end
end