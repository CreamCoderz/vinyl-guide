require 'spec_helper'

describe Genre do
  context "validations" do
    it { should validate_uniqueness_of(:name) }
  end

  context "associations" do
    it { should have_many(:ebay_items) }
  end

  describe "#find_by_ebay_genre" do
    let(:genre) { Factory.create(:genre, :name => "Reggae") }
    let(:genre_alias) { Factory.create(:genre_alias, :name => "Roots Reggae", :genre => genre) }

    it "returns the genre directly matching the genre_name" do
      Genre.find_by_ebay_genre(genre.name).should == genre
    end

    it "returns the genre associated with a genre alias matchine the genre_name" do
      Genre.find_by_ebay_genre(genre_alias.name).should == genre
    end

    it "returns nil when no genre is found" do
      Genre.find_by_ebay_genre("missing genre").should be_nil
    end
  end

  describe "#update_ebay_items" do
    let(:genre_name) { "new_genre" }

    before do
      @ebay_item = Factory.create(:ebay_item, :genrename => "new_genre", :genre => nil)
    end

    it "updates the genre of all ebay items that match the genrename" do
      genre = Factory.create(:genre, :name => genre_name)
      @ebay_item.reload.genre.should == genre
    end

    it "always returns true" do
      Factory.build(:genre).send(:update_ebay_items).should be_true
    end
  end
end