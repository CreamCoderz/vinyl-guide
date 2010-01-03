class EbayItemDataBuilder

  def initialize
    @num = 0
  end

  def make
    @ebayitem = EbayItemDataSubset.new(@num)
    return self
  end

  def without_specifics
    @ebayitem.size = nil
    @ebayitem.subgenre = nil
    @ebayitem.condition = nil
    @ebayitem.speed = nil
    return self
  end

  def without_description
    @ebayitem.description = nil
    return self
  end

  def method_missing(method, *args, &block)
    if @ebayitem.respond_to?(method)
      @ebayitem.send(method, *args, &block)
    else
      raise NoMethodError
    end
  end

  def to_data
    @num += 1
    description, itemid, endtime, starttime, url,
            galleryimg, bidcount, price, sellerid, title, country, pictureimgs,
            currencytype, size=nil, subgenre=nil, condition=nil, speed=nil
    EbayItemData.new(@ebayitem.description, @ebayitem.itemid, @ebayitem.endtime, @ebayitem.starttime, @ebayitem.url,
            @ebayitem.galleryimg, @ebayitem.bidcount, @ebayitem.price, @ebayitem.sellerid, @ebayitem.title, @ebayitem.country, @ebayitem.pictureimgs,
            @ebayitem.currencytype, @ebayitem.size, @ebayitem.subgenre, @ebayitem.condition, @ebayitem.speed)
  end

  class EbayItemDataSubset
    #TODO: pull in this accessor list dynamically from EbayItemData
    attr_accessor :description, :itemid, :endtime, :starttime, :url, :galleryimg, :bidcount, :price, :sellerid, :title,
            :pictureimgs, :currencytype, :size, :subgenre, :condition, :speed, :country

    def initialize(num)
      @description = "the description #{num}"
      @itemid = num
      @endtime = DateTime.parse('2009-11-22T10:20:00+00:00') + num
      @starttime = DateTime.parse('2009-11-22T10:20:00+00:00') + num + 1
      @url = "http://www.ebay.com/#{num}"
      @galleryimg = "http://www.ebay.com/img#{num}"
      @bidcount = num + 1
      @price = 10.00 + num
      @sellerid = "seller#{num}"
      @title = "title #{num}"
      @pictureimgs = nil
      @currencytype = "#{num} USD"
      @size = "#{num} 12\""
      @subgenre = "#{num} Roots"
      @condition = "#{num} Used"
      @speed = "#{num} rpm"
      @country = "#{num}land"
    end

  end

end