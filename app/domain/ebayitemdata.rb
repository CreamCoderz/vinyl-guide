class EbayItemData
  attr_reader :description, :itemid, :endtime, :starttime, :url, :galleryimg, :bidcount, :price, :sellerid, :title, :pictureimgs, :currencytype, :size, :subgenre, :genre, :condition, :speed, :country

  def initialize(params)
    @description = params[:description]
    @itemid = params[:itemid]
    @endtime = params[:endtime]
    @starttime = params[:starttime]
    @url = params[:url]
    @galleryimg = params[:galleryimg]
    @bidcount = params[:bidcount]
    @price = params[:price]
    @sellerid = params[:sellerid]
    @title = params[:title]
    @pictureimgs = params[:pictureimgs]
    @size = params[:size]
    @subgenre = params[:subgenre]
    @genre = params[:genre]
    @condition = params[:condition]
    @speed = params[:speed]
    @country = params[:country]
    @currencytype = params[:currencytype]
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
    result = result && self.genre == other.genre
  end



end