require 'spec_helper'

describe FavoritesController do

  before do
    @user = Factory(:confirmed_user)
    request.stub(:referrer).and_return(root_path)
  end

  describe "#create" do
    before do
      @ebay_item = Factory(:ebay_item)
      request.stub(:referrer).and_return(root_path)
    end
    context "success" do
      context "with html format" do
        before do
          sign_in @user
          post :create, :user_id => @user.id, :favorite => {:ebay_item_id => @ebay_item.id}
        end
        it "creates a favorite" do
          Favorite.find_by_user_id_and_ebay_item_id(@user.id, @ebay_item.id).should be_present
        end
        it "redirects to the referrer" do
          response.should redirect_to(root_path)
        end
        it "sets a flash message" do
          flash[:notice].should include('favorite')
        end
      end
      context "with json format" do
        before do
          sign_in @user
          post :create, :user_id => @user.id, :favorite => {:ebay_item_id => @ebay_item.id}, :format => 'json'
        end
        it "responds with success" do
          response.should be_successful
        end
      end
    end
    context "failure" do
      context "bad request" do
        context "with html format" do
          before do
            sign_in @user
            post :create, :user_id => @user.id
          end
          it "sets an error a flash message" do
            flash[:notice].should include('error')
          end
        end
        context "with json format" do
          before do
            sign_in @user
            post :create, :user_id => @user.id, :format => 'json'
          end
          it "responds with a 400" do
            response.status.should == 400
          end
          it "includes errors in the json" do
            JSON.parse(response.body)['error'].should be_present
          end
        end
      end
      context "unauthenticated" do
        it "redirects a user to the sign_in page" do
          post :create, :user_id => @user.id, :favorite => {:ebay_item_id => @ebay_item.id}
          response.should redirect_to(new_user_session_path)
        end
      end
      context "unauthorized" do
        before do
          sign_in Factory(:confirmed_user)
          post :create, :user_id => @user.id, :favorite => {:ebay_item_id => @ebay_item.id}
        end
        it "responds with 403" do
          response.status.should == 403
        end
        it "should not create the favorite" do
          Favorite.find_by_user_id_and_ebay_item_id(@user.id, @ebay_item.id).should be_nil
        end
      end
    end
  end

  describe "#destroy" do
    before do
      @favorite = Factory(:favorite, :user => @user)
    end
    context "success" do
      context "with html format" do
        before do
          sign_in @user
          delete :destroy, :user_id => @user.id, :id => @favorite.id
        end
        it "destroys the favorite" do
          Favorite.find_by_id(@favorite.id).should be_nil
        end
        it "redirects to the referrer" do
          response.should redirect_to(root_path)
        end
      end
      context "with json format" do
        before do
          sign_in @user
          delete :destroy, :user_id => @user.id, :id => @favorite.id, :format => 'json'
        end
        it "redirects to the referrer" do
          response.should be_successful
        end
      end
    end
    context "unauthorized" do
      before do
        sign_in Factory(:confirmed_user)
        delete :destroy, :user_id => @user.id, :id => @favorite.id
      end
      it "responds with 403" do
        response.status.should == 403
      end
      it "should not delete the favorite" do
        @favorite.reload.should be_present
      end
    end
  end

  describe "#index" do
    before do
      sign_in @user
      @favorite = Factory(:favorite, :user => @user)
      get :index, :user_id => @user.id
    end
    it "assigns @favorites" do
      assigns[:favorites].should == [@favorite]
    end
  end

end