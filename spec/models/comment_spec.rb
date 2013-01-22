require 'spec_helper'

describe Comment do

  context "associations" do
    it { should belong_to(:parent, :polymorphic => true) }
    it { should belong_to(:user) }
  end

  context "validations" do
    it { should validate_presence_of(:parent) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body, :maximum => Comment::MAX_LENGTH) }
    it { should validate_presence_of(:user) }
  end

  describe ".with_recent_unique_parents" do
    before do
      @ebay_item1 = Factory(:ebay_item)
      @ebay_item2 = Factory(:ebay_item)
      @comment1 = Factory(:comment, :parent => @ebay_item1, :created_at => 1.day.ago)
      @comment2 = Factory(:comment, :parent => @ebay_item2, :created_at => 2.days.ago)
    end
    it "returns the comments in reverse chronological order" do
      Comment.with_recent_unique_parents.should == [@comment1, @comment2]
    end
    it "returns the comments with unique parent ids" do
      comment3 = Factory(:comment, :parent => @ebay_item1, :created_at => 5.minutes.ago)
      Comment.with_recent_unique_parents.should == [comment3, @comment2]
    end
  end

end