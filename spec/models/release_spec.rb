require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Release do
  before do
    @valid_attributes = {
            :title => "value for title",
            :artist => "value for artist",
            :year => 1978,
            :label => "value for label",
            :matrix_number => "value for matrix_number",
            :format => Format::SINGLE
    }
  end

  describe "associations" do
    it "should have one format" do
      release = Factory(:release, :format => Format::LP)
      release.format.should == Format::LP
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
      @valid_attributes[:label] = "harry j"
      Release.create!(@valid_attributes)
      @valid_attributes[:format] = Format::EP
      Release.create!(@valid_attributes)
      Release.create(@valid_attributes).errors.on(:title).should == "must not match an existing combination of fields"
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
      @label_word = @valid_attributes[:label][/[^ ]+/].first
      @matrix_word = @valid_attributes[:matrix_number][/[^ ]+/].first
      @query_words = [@title_word, @artist_word, @label_word, @matrix_word]
    end

    it "should return an empty result set when no items exist" do
      results = Release.search(:query => @title_word)[0]
      results.should be_empty
    end

    it "should return an empty result set for a query that doesn't match" do
      results = Release.search(:query => "foo")[0]
      results.should be_empty
    end

    it "should find 1 result for a query word" do
      expected_record = Release.create!(@valid_attributes)
      @query_words.each do |word|
        results = Release.search(word)[0]
        results.length.should == 1
        results[0].id.should == expected_record.id
      end
    end

    it "should use the paginator" do
      title = "ital corner"
      21.times { Factory.create(:release, :title => title) }
      results = Release.search(:query => title, :page => 2)[0]
      results.length.should == 1
    end
  end
end
