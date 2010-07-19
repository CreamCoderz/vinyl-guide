class FeedItem
  attr_reader :title, :link, :description, :pubDate

  def initialize(title, link, description, pub_date)
   @title = title
   @link = link
   @description = description 
   @pub_date = pub_date
  end

end
