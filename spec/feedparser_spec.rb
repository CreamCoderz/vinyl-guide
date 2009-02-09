require 'feedparser'

module FeedParserSpec

 FEED_HEADER = "<?xml version=\"1.0\"?>\n" +
                "<rss version=\"2.0\">\n" +
                "  <channel>\n" +
                "    <title>Ebay search results</title>\n" +
                "    <link>http://www.ebay.com/</link>\n" +
                "    <description>Search results .</description>\n" +
                "    <language>en-us</language>\n" +
                "    <pubDate>Tue, 10 Jun 2003 04:00:00 GMT</pubDate>\n" +
                "    <lastBuildDate>Tue, 10 Jun 2003 09:41:01 GMT</lastBuildDate>\n" +
                "    <docs>http://www.ebay.com/tech/rss</docs>\n" +
                "    <generator>Weblog Editor 2.0</generator>\n" +
                "    <managingEditor>editor@example.com</managingEditor>\n" +
                "    <webMaster>webmaster@example.com</webMaster>\n" +
                "    <ttl>5</ttl>\n"
  
  FEED_FOOTER = " \n" +
                "  </channel>\n" +
                "</rss>"

  @jazzboTitle = "Prince Jazzbo - Natty Pass Thru"
  @jazzboLink = "http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=380092356904&_trksid=p3907.m32&_trkparms=tab%3DWatching"
  @jazzboDescription = "Rare original Prince Jazzo - Natty Pass Thru LP"
  @jazzboPubDate = "Tue, 03 Jun 2003 09:39:21 GMT"
  @congosTitle = "Congos - Heart of the Congos"
  @congosLink = "http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=400000000000&_trksid=p4000.m32&_trkparms=tab%3DWatching"
  @congosDescription = "Heart of the Congos original pressing, silk screen"
  @congosPubDate = "Fri, 30 May 2003 11:06:42 GMT"

  FEED_WITH_ITEMS = FEED_HEADER + 
                "    <item>\n" +
                "      <title>" + @jazzboTitle + "</title>\n" +
                "      <link>" + @jazzboLink + "</link>\n" +
                "      <description>" + @jazzboDescription + "</description>\n" +
                "      <pubDate>" + @jazzboPubDate + "</pubDate>\n" +
                "    </item>\n" +
                " \n" +
                "    <item>\n" +
                "      <title>" + @congosTitle + "</title>\n" +
                "      <link>" + @congosLink + "</link>\n" +
                "      <description>" + @congosDescription + "</description>\n" +
                "      <pubDate>" + @congosPubDate + "</pubDate>\n" +
                "    </item>\n" +
		FEED_FOOTER
  
  JAZZBO_RECORD = RecordData.new(@jazzboTitle, @jazzboLink, @jazzboDescription, @jazzboPubDate) 
  CONGOS_RECORD = RecordData.new(@congosTitle, @congosLink, @congosDescription, @congosPubDate) 
  
describe FeedParser do
  it "should be empty if no items exist" do
    @feed = FEED_HEADER + FEED_FOOTER
    FeedParser.parse(@feed).length.should == 0
  end

  it "should parse the feed into a hash" do
    @items = FeedParser.parse(FEED_WITH_ITEMS)
    @items.length.should == 2
    FeedParserSpec.checkFeedItem(@items[0], JAZZBO_RECORD) 
    FeedParserSpec.checkFeedItem(@items[1], CONGOS_RECORD) 
  end

end

  def self.checkFeedItem(actualItem, expectedItem)
    actualItem.title.should == expectedItem.title 
    actualItem.link.should == expectedItem.link 
    actualItem.description.should == expectedItem.description 
    actualItem.pubDate.should == expectedItem.pubDate 
  end

end
