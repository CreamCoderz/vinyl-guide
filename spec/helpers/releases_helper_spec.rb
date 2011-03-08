require 'spec_helper'

describe ReleasesHelper do
  include ReleasesHelper
  describe "#display" do
    it "should generate a display name for a release model" do
      release = Factory(:release, :artist => "Prince Jazzbo", :title => "Ital corner",
                        :matrix_number => "", :label_entity => nil, :format => Format::LP)
      release_title_for(release).should == "Ital corner - Prince Jazzbo - 1976 - LP"
    end
  end
end
