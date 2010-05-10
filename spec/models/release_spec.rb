require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Release do
  before(:each) do
    @valid_attributes = {
            :title => "value for title",
            :artist => "value for artist",
            :year => 1978,
            :label => "value for label",
            :matrix_number => "value for matrix_number"
    }
  end

  it "should create a new instance given valid attributes" do
    Release.create!(@valid_attributes)
    lambda { Release.create!(@valid_attributes) }.should raise_error
    @valid_attributes[:title] = "different value for title"
    Release.create!(@valid_attributes)
    @valid_attributes[:artist] = "different value for artist"
    Release.create!(@valid_attributes)
    @valid_attributes[:year] = 1970
    Release.create!(@valid_attributes)
    @valid_attributes[:label] = "harry j"
    Release.create!(@valid_attributes)
    Release.create(@valid_attributes).errors.on(:title).should == "must not match an existing combination of fields"
  end
end
