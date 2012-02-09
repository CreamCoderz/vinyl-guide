require "spec_helper"

describe User do

  before do
    Factory(:user)
  end

  context "validations" do
    it { should validate_uniqueness_of :username }

    it "allows alphanumeric and _ characters" do
      Factory.build(:user, :username => "jah_chicken_3").should be_valid
    end
    it "does not allow other characters" do
      Factory.build(:user, :username => "jah**chicken$%^&3").should_not be_valid
    end
    it "does not allow a length over characters" do
      Factory.build(:user, :username => "jah_chicken_0123456789").should_not be_valid
    end
  end

  context "callbacks" do
    context "after_create" do
      it "autoconfirms a user" do
        user = Factory.build(:user)
        user.should_receive(:confirm!)
        user.save!
      end
    end
  end

end