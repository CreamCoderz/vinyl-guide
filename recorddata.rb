class RecordData
  attr_reader :title, :link, :description, :pubDate

  def initialize(title, link, description, pubDate)
   @title = title
   @link = link
   @description = description 
   @pubDate = pubDate 
  end

end
