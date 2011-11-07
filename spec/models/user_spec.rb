require "spec_helper"

describe User do

  context "validations" do
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

end