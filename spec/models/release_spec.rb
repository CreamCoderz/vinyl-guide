require 'spec_helper'

describe Release do
  before do
    label = Factory(:label, :name => "value for label")
    @valid_attributes = {
        :title => "value for title",
        :artist => "value for artist",
        :year => 1978,
        :label_id => label.id,
        :matrix_number => "value for matrix_number",
        :format_id => Format::SINGLE.id
    }
  end

  describe "associations" do
    it "should have one format" do
      release = Factory(:release, :format => Format::LP)
      #noinspection RubyArgCount
      release.format.should == Format::LP
    end

    it "should order ebay items by descending modified date" do
      recent_update_ebay_item = Factory(:ebay_item, :updated_at => 1.day.ago)
      ebay_item = Factory(:ebay_item, :updated_at => 5.days.ago)
      release = Factory(:release)
      release.ebay_items << recent_update_ebay_item
      release.ebay_items << ebay_item
      release.save
      release.reload.ebay_items.should == [recent_update_ebay_item, ebay_item]
    end

    it "should belong to label" do
      release = Factory(:release)
      release.label_entity = label = Factory(:label)
      release.save
      release.reload.label_entity.should == label
    end

    it "should accept nested attributes for label" do
      release = Factory(:release)
      release.label_entity_attributes= {:name => 'Channel One'}
      release.save
      release.reload.label_entity.name.should == 'Channel One'
    end
  end

  describe "constraints" do
    it "should create a new instance given valid attributes" do
      Release.create!(@valid_attributes)
      lambda { Release.create!(@valid_attributes) }.should raise_error
      @valid_attributes[:title] = "different value for title"
      Release.create!(@valid_attributes)
      @valid_attributes[:artist] = "different value for artist"
      Release.create!(@valid_attributes)
      @valid_attributes[:year] = 1970
      Release.create!(@valid_attributes)
      @valid_attributes[:label_id] = Factory(:label, :name =>"harry j").id
      Release.create!(@valid_attributes)
      @valid_attributes[:format_id] = (Format::EP).id
      Release.create!(@valid_attributes)
      Release.create(@valid_attributes).errors.on(:title).should == "The release must not match an existing combination of fields"
    end

    it "should allow LP, EP, or single for the format field" do
      [Format::LP, Format::EP, Format::SINGLE].each do |format|
        @valid_attributes[:format] = format
        Release.create!(@valid_attributes)
      end
    end

    describe "#create" do
      it "should not allow any other format value" do
        @valid_attributes[:format_id] = 20000
        Release.create(@valid_attributes).errors.on(:format).should == "the format must exist"
      end

      it "should only allow 4 digit dates" do
        @valid_attributes[:year] = 12
        Release.create(@valid_attributes).errors.on(:year).should == "the year must have 4 digits and be valid"
      end
    end

    describe "#update" do
      it "should no allow any other format values on update" do
        Release.create!(@valid_attributes)
        @valid_attributes[:format_id] = 20000
        Release.create(@valid_attributes).errors.on(:format).should == "the format must exist"
      end
    end

  end

  describe "#link" do
    it "should generate a link" do
      release = Factory.create(:release)
      release.link.should == "/releases/#{release.id}"
    end
  end

  describe ".search" do

    before do
      @title_word = @valid_attributes[:title][/[^ ]+/].first
      @artist_word = @valid_attributes[:artist][/[^ ]+/].first
      @matrix_word = @valid_attributes[:matrix_number][/[^ ]+/].first
      @query_words = [@title_word, @artist_word, @matrix_word]
      Release.reindex
    end


    it "finds 1 result for a query word" do
      expected_record = Release.create!(@valid_attributes)
      @query_words.each do |word|
        results = Release.search do
          with(:title).starting_with(word)
        end.results
        results.total_entries.should == 1
        results[0].id.should == expected_record.id
      end
    end

  end
end
