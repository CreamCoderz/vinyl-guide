
class EbayItemData
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

  def ==(other)
    result = other.kind_of?(EbayItemData)
    result = result && self.description == other.description
    result = result && self.itemid == other.itemid
    result = result && self.endtime == other.endtime
    result = result && self.starttime == other.starttime
    result = result && self.url == other.url
    result = result && self.galleryimg == other.galleryimg
    result = result && self.bidcount == other.bidcount
    result = result && self.price == other.price
    result = result && self.sellerid == other.sellerid
  end



end