require 'feedparser'

describe FeedParser do
  it "should parse the feed into a hash" do
    @jazzboTitle = "Prince Jazzbo - Natty Pass Thru"
    @congosTitle = "Congos - Heart of the Congos"
    @feed = "<?xml version=\"1.0\"?>\n" +
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
                "    <ttl>5</ttl>\n" +
                " \n" +
                "    <item>\n" +
                "      <title>" + @jazzboTitle + "</title>\n" +
                "      <link>http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=380092356904&_trksid=p3907.m32&_trkparms=tab%3DWatching</link>\n" +
                "      <description>Rare original Prince Jazzo - Natty Pass Thru LP.</description>\n" +
                "      <pubDate>Tue, 03 Jun 2003 09:39:21 GMT</pubDate>\n" +
                "    </item>\n" +
                " \n" +
                "    <item>\n" +
                "      <title>" + @congosTitle + "</title>\n" +
                "      <link>http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=400000000000&_trksid=p4000.m32&_trkparms=tab%3DWatching</link>\n" +
                "      <description>Heart of the Congos original pressing, silk screen</description>\n" +
                "      <pubDate>Fri, 30 May 2003 11:06:42 GMT</pubDate>\n" +
                "    </item>\n" +
                " \n" +
                "  </channel>\n" +
                "</rss>"
    @items = FeedParser.parse(@feed)
    @items.length.should == 2
    @items[0].title.should == @jazzboTitle 
    @items[1].title.should == @congosTitle 
  end
end
