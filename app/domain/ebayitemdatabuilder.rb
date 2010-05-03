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
      return self
    else
      raise NoMethodError
    end
  end

  def to_data
    @num += 1
    description, itemid, endtime, starttime, url,
            galleryimg, bidcount, price, sellerid, title, country, pictureimgs,
            currencytype, size=nil, subgenre=nil, condition=nil, speed=nil
    EbayItemData.new(
            :description => @ebayitem.description,
                    :itemid => @ebayitem.itemid,
                    :endtime => @ebayitem.endtime,
                    :starttime => @ebayitem.starttime,
                    :url => @ebayitem.url,
                    :galleryimg => @ebayitem.galleryimg,
                    :bidcount => @ebayitem.bidcount,
                    :price => @ebayitem.price,
                    :sellerid => @ebayitem.sellerid,
                    :title => @ebayitem.title,
                    :country => @ebayitem.country,
                    :pictureimgs => @ebayitem.pictureimgs,
                    :currencytype => @ebayitem.currencytype,
                    :size => @ebayitem.size,
                    :subgenre => @ebayitem.subgenre,
                    :condition => @ebayitem.condition,
                    :speed => @ebayitem.speed)
  end

  #TODO: this is convenient but it creates a dependency to activerecord

  def to_items(method, *args, &block)
    datas = []
    args.each do |arg|
      make
      self.send(method, arg)
      yield self if block_given?
      datas << to_item
    end
    datas
  end

  def to_item
    ebay_item_data = to_data
    ebay_item = EbayItem.new(:itemid => ebay_item_data.itemid, :title => ebay_item_data.title, :description => ebay_item_data.description,
            :bidcount => ebay_item_data.bidcount, :price => ebay_item_data.price, :endtime => ebay_item_data.endtime,
            :starttime => ebay_item_data.starttime, :url => ebay_item_data.url, :galleryimg => ebay_item_data.galleryimg,
            :sellerid => ebay_item_data.sellerid, :country => ebay_item_data.country, :size => ebay_item_data.size,
            :speed => ebay_item_data.speed, :condition => ebay_item_data.condition, :subgenre => ebay_item_data.subgenre,
            :currencytype => ebay_item_data.currencytype, :hasimage => ebay_item_data.galleryimg != nil)

  end

  def to_many_items(count)
    datas = []
    (1..count).each do
      make
      datas << to_item
    end
    datas
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
      @currencytype = "USD"
      @size = "#{num} 12\""
      @subgenre = "#{num} Roots"
      @condition = "#{num} Used"
      @speed = "#{num} rpm"
      @country = "#{num}land"
    end

  end

end