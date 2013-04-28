require 'spec_helper'

describe Genre do
  context "validations" do
    it { should validate_uniqueness_of(:name) }
  end

  describe "#find_by_ebay_genre" do
    let(:genre) { Factory.create(:genre, :name => "Reggae") }
    let(:genre_alias) { Factory.create(:genre_alias, :name => "Roots Reggae", :genre => genre) }

    it "returns the genre directly matching the genre_name" do
      p genre
      Genre.find_by_ebay_genre(genre.name).should == genre
    end

    it "returns the genre associated with a genre alias matchine the genre_name" do
      Genre.find_by_ebay_genre(genre_alias.name).should == genre
    end

    it "returns nil when no genre is found" do
      Genre.find_by_ebay_genre("missing genre").should be_nil
    end
  end
end