class EbayItemData
  attr_reader :description, :itemid, :endtime, :starttime, :url, :galleryimg, :bidcount, :price, :sellerid, :title, :pictureimgs, :currencytype, :size, :subgenre, :condition, :speed, :country

  def initialize(description, itemid, endtime, starttime, url, galleryimg, bidcount, price, sellerid, title, country, pictureimgs, currencytype, size=nil, subgenre=nil, condition=nil, speed=nil)
    @description = description
    @itemid = itemid
    @endtime = endtime
    @starttime = starttime
    @url = url
    @galleryimg = galleryimg
    @bidcount = bidcount
    @price = price
    @sellerid = sellerid
    @title = title
    @pictureimgs = pictureimgs
    @size = size
    @subgenre = subgenre
    @condition = condition
    @speed = speed
    @country = country
    @currencytype = currencytype
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
    result = result && self.title == other.title
    result = result && self.pictureimgs == other.pictureimgs
    result = result && self.currencytype == other.currencytype
    result = result && self.size == other.size
    result = result && self.subgenre == other.subgenre
    result = result && self.condition == other.condition
    result = result && self.speed == other.speed
    result = result && self.country == other.country
  end



end