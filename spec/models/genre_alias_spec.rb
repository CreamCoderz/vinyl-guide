require 'spec_helper'

describe GenreAlias do
  context "validations" do
    before { Factory.create(:genre_alias) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :genre_id }
    it { should validate_uniqueness_of :name }
  end

  context "associations" do
    it { should belong_to :genre }
  end

  describe "#update_ebay_items" do
    let(:genre_name) { "new_genre" }
    let(:genre) { Factory.create(:genre, :name => "other genre") }

    before do
      @ebay_item = Factory.create(:ebay_item, :genrename => genre_name, :genre => nil)
    end

    it "updates the genre of all ebay items that match the genrename" do
      Factory.create(:genre_alias, :name => genre_name, :genre => genre)
      @ebay_item.reload.genre.should == genre
    end

    it "always returns true" do
      Factory.build(:genre_alias).send(:update_ebay_items).should be_true
    end
  end
end