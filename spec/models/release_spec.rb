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

  context "associations" do
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

  context "callbacks" do
    describe "#before_save" do
      context "no label exists" do
        before do
          @release = Release.new(@valid_attributes.merge("label_entity_attributes" => {"name" => "Studio One"}))
          @release.save
        end
        it "creates the label if none exists" do
          Label.find_by_name("Studio One").should_not be_nil
        end
      end
      context "a label exists" do
        before do
          @label = Factory(:label)
          @release = Release.new(@valid_attributes.merge("label_entity_attributes" => {"name" => @label.name}))
          @release.save
        end
        it "creates a release associated with an existing label" do
          @release.reload.label_entity.should == @label
        end
      end
      context "a release, already associated with a label" do
        before do
          @label = Factory(:label)
          @release = Release.new(@valid_attributes)
          @release.label_entity = @label
          @release.save
        end
        context "has it's label updated" do
          before do
            @release.update_attributes("label_entity_attributes" => {"id" => @label.id, "name" => "a new name"})
          end
          it "does not modify the previously bound label" do
            Label.find_by_name(@label.name).should_not be_nil
          end
          it "creates the new label" do
            Label.find_by_name("a new name").should_not be_nil
          end
        end
        context "has it's other properties updated" do
          before do
            @release.update_attributes("title" => "newreleasename")
          end
          it "updates the release title" do
            @release.reload.title.should == "newreleasename"
          end
          it "should not affect the releases label" do
            @release.reload.label_entity.should == @label
          end
        end
      end
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

  describe "#ebay_item" do
    before do
      @release = Factory(:release)
    end
    context "release has ebay items" do
      before do
        @canonical_ebay_item = Factory(:ebay_item, :release => @release, :updated_at => Time.now + 10)
        Factory(:ebay_item, :release => @release, :updated_at => Time.now - 10)
      end

      it "returns the first ebay_item" do
        @release.ebay_item.should == @canonical_ebay_item
      end
    end

    it "returns nil" do
      @release.ebay_item.should be_nil
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
      @title_word = @valid_attributes[:title][/[^ ]+/]
      @artist_word = @valid_attributes[:artist][/[^ ]+/]
      @matrix_word = @valid_attributes[:matrix_number][/[^ ]+/]
      @query_words = [@title_word, @artist_word, @matrix_word]
    end

    it "should return an empty result set when no items exist" do
      results = Release.search(:query => @title_word).items
      results.should be_empty
    end

    it "should return an empty result set for a query that doesn't match" do
      results = Release.search(:query => "foo").items
      results.should be_empty
    end

    it "should find 1 result for a query word" do
      expected_record = Release.create!(@valid_attributes)
      @query_words.each do |word|
        results = Release.search(:query => word).items
        results.length.should == 1
        results[0].id.should == expected_record.id
      end
    end

    it "should use the paginator" do
      title = "ital corner"
      21.times { Factory.create(:release, :title => title) }
      results = Release.search(:query => title, :page => 2).items
      results.length.should == 1
    end
  end
end