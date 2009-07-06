require 'spec'
require File.dirname(__FILE__) + '/../../app/util/feedparser'

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

  @jazzbo_title = "Prince Jazzbo - Natty Pass Thru"
  @jazzbo_link = "http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=380092356904&_trksid=p3907.m32&_trkparms=tab%3DWatching"
  @jazzbo_description = "Rare original Prince Jazzo - Natty Pass Thru LP"
  @jazzbo_pub_date = "Tue, 03 Jun 2003 09:39:21 GMT"
  @congos_title = "Congos - Heart of the Congos"
  @congos_link = "http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=400000000000&_trksid=p4000.m32&_trkparms=tab%3DWatching"
  @congos_description = "Heart of the Congos original pressing, silk screen"
  @congos_pub_date = "Fri, 30 May 2003 11:06:42 GMT"

  FEED_WITH_ITEMS = FEED_HEADER + 
                "    <item>\n" +
                "      <title>" + @jazzbo_title + "</title>\n" +
                "      <link>" + @jazzbo_link + "</link>\n" +
                "      <description>" + @jazzbo_description + "</description>\n" +
                "      <pubDate>" + @jazzbo_pub_date + "</pubDate>\n" +
                "    </item>\n" +
                " \n" +
                "    <item>\n" +
                "      <title>" + @congos_title + "</title>\n" +
                "      <link>" + @congos_link + "</link>\n" +
                "      <description>" + @congos_description + "</description>\n" +
                "      <pubDate>" + @congosPubDate + "</pubDate>\n" +
                "    </item>\n" +
		FEED_FOOTER
  
  JAZZBO_RECORD = RecordData.new(@jazzbo_title, @jazzbo_link, @jazzbo_description, @jazzbo_pub_date)
  CONGOS_RECORD = RecordData.new(@congos_title, @congos_link, @congos_description, @congos_pub_date)
  
describe FeedParser do
  it "should be empty if no items exist" do
    feed = FEED_HEADER + FEED_FOOTER
    FeedParser.parse(feed).length.should == 0
  end

  it "should parse the feed into a hash" do
    items = FeedParser.parse(FEED_WITH_ITEMS)
    items.length.should == 2
    FeedParserSpec.check_feed_item(items[0], JAZZBO_RECORD)
    FeedParserSpec.check_feed_item(items[1], CONGOS_RECORD)
  end

end

  def self.check_feed_item(actual_item, expected_item)
    actual_item.title.should == expected_item.title
    actual_item.link.should == expected_item.link
    actual_item.description.should == expected_item.description
    actual_item.pubDate.should == expected_item.pubDate
  end

end
