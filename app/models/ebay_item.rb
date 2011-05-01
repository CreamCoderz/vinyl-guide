class EbayItem < ActiveRecord::Base
  SEARCHABLE_FIELDS = ['title']
  DESC, ASC = 'desc', 'asc'

  FORMATS_BY_SIZE = {
      Format::LP => ["LP (12-Inch)", "LP", '12"'],
      Format::EP => ['EP, Maxi (10, 12-Inch)', '10"', 'Single, EP (12-Inch)'],
      Format::SINGLE => ["size=? OR size=?", '7"', "Single (7-Inch)"]
  }

  validates_numericality_of :itemid, :only_integer => true
  validates_uniqueness_of :itemid
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :url

  belongs_to :release
  has_many :pictures, :foreign_key => "ebay_item_id"
  belongs_to :format

  named_scope :all_time, lambda {}
  named_scope :singles, :conditions => ["format_id = #{Format::SINGLE.id}"], :order => "created_at DESC"
  named_scope :eps, :conditions => ["format_id = #{Format::EP.id}"], :order => "created_at DESC"
  named_scope :lps, :conditions => ["format_id = #{Format::LP.id}"], :order => "created_at DESC"
  #TODO: this should really be where ebay_item has format of nil
  named_scope :other, :conditions => ["size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=?", "LP (12-Inch)", "LP", 'EP, Maxi (10, 12-Inch)', '10"', '7"', "Single (7-Inch)", '12"']

  named_scope :today, :conditions => "endtime > NOW()-INTERVAL 1 DAY"
  named_scope :week, :conditions => "endtime > NOW()-INTERVAL 1 WEEK"
  named_scope :month, :conditions => "endtime > NOW()-INTERVAL 1 MONTH"
  named_scope :top_items, :conditions => "endtime > NOW()-INTERVAL 1 DAY", :order => "price DESC", :limit => 4

  cattr_reader :per_page
  @@per_page = 20

  before_save do |item|
    item.format ||= FORMATS_BY_SIZE.keys.detect do |format|
      FORMATS_BY_SIZE[format].include?(item.size)
    end
  end

  after_save { |item| item.index! }

  searchable do
    text(:title_text) { title }
    text(:sellerid)
    text(:description) { description.present? ? description[1..1000] : nil }
    string :title
    long(:endtime) { endtime.to_i }
    float :price
    boolean(:mapped) { release.present? }
  end

  def related_items
    release ? release.ebay_items.all(:conditions => "id != #{id}") : []
  end

  def link
    "/#{self.id}"
  end

end