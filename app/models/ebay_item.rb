class EbayItem < ActiveRecord::Base
  SEARCHABLE_FIELDS = ['title']
  DESC, ASC = 'desc', 'asc'

  FORMATS_BY_SIZE = {
      Format::LP => ["LP (12-Inch)", "LP", '12"'],
      Format::EP => ['EP, Maxi (10, 12-Inch)', '10"', 'Single, EP (12-Inch)', 'Single, EP (10-Inch)'],
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

  scope :all_time, lambda {}
  scope :singles, :conditions => {:format_id => Format::SINGLE.id}, :order => "created_at DESC"
  scope :eps, :conditions => {:format_id => Format::EP.id}, :order => "created_at DESC"
  scope :lps, :conditions => {:format_id => Format::LP.id}, :order => "created_at DESC"
  scope :other, :conditions => {:format_id => nil}

  scope :today, :conditions => "endtime > NOW()-INTERVAL 1 DAY"
  scope :week, :conditions => "endtime > NOW()-INTERVAL 1 WEEK"
  scope :month, :conditions => "endtime > NOW()-INTERVAL 1 MONTH"
  scope :top_items, :conditions => "endtime > NOW()-INTERVAL 1 DAY", :order => "price DESC", :limit => 4

  cattr_reader :per_page
  @@per_page = 20

  before_save :set_format

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

  private
  def set_format
    self.format ||= FORMATS_BY_SIZE.keys.detect do |format|
      FORMATS_BY_SIZE[format].include?(size)
    end
  end
end