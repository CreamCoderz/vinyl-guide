
class EbayItem
  attr_reader :description, :itemid, :endtime, :starttime, :url, :galleryimg, :bidcount, :price, :sellerid

  def initialize(description, itemid, endtime, starttime, url, galleryimg, bidcount, price, sellerid)
    @description = description
    @itemid = itemid
    @endtime = endtime
    @starttime = starttime
    @url = url
    @galleryimg = galleryimg
    @bidcount = bidcount
    @price = price
    @sellerid = sellerid
  end

end