class EbayItem < ActiveRecord::Base
  include ImageWriter
  include ImageClient
  extend FriendlyId

  SEARCHABLE_FIELDS = ['title']
  DESC, ASC = 'desc', 'asc'

  FORMATS_BY_SIZE = {
      Format::LP => ["LP (12-Inch)", "LP", '12"'],
      Format::EP => ['EP, Maxi (10, 12-Inch)', '10"', 'Single, EP (12-Inch)', 'Single, EP (10-Inch)'],
      Format::SINGLE => ["size=? OR size=?", '7"', "Single (7-Inch)"]
  }

  attr_accessor :comment

  validates_numericality_of :itemid, :only_integer => true
  validates_uniqueness_of :itemid
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :title
  validates_presence_of :url

  belongs_to :release
  belongs_to :format
  belongs_to :genre

  has_many :pictures, :foreign_key => "ebay_item_id"
  has_many :comments, :as => :parent, :order => "created_at DESC"

  mount_uploader :gallery_image, GalleryImageUploader
  friendly_id :title, :use => :slugged

  scope :reggae, where(:genre_id => Genre::REGGAE_SKA_AND_DUB)

  scope :all_time, lambda {}
  scope :singles, where(:format_id => Format::SINGLE.id)
  scope :eps, where(:format_id => Format::EP.id)
  scope :lps, where(:format_id => Format::LP.id)
  scope :other, where(:format_id => nil)

  # MySQL is wrongly choosing indexes.. force it to use a single-column index on endtime
  scope :today, from("ebay_items force index (index_ebay_items_on_endtime)").where("endtime > NOW()-INTERVAL 1 DAY")
  scope :week, from("ebay_items force index (index_ebay_items_on_endtime)").where("endtime > NOW()-INTERVAL 1 WEEK")
  scope :month, from("ebay_items force index (index_ebay_items_on_endtime)").where("endtime > NOW()-INTERVAL 1 MONTH")
  scope :top_items, from("ebay_items force index (index_ebay_items_on_endtime)").where("endtime > NOW()-INTERVAL 1 DAY").order("price DESC")

  cattr_reader :per_page
  @@per_page = 20

  before_save :set_format
  before_save :set_genre
  after_create :save_gallery_image
  after_destroy :destroy_image

  searchable do
    text(:title_text) { title }
    text(:sellerid)
    #text(:description) { description.present? ? description[1..100] : nil }
    string :title
    long(:endtime) { endtime.to_i }
    float :price
    boolean(:mapped) { release.present? }
  end

  def related_items
    release ? release.ebay_items.where("id != #{id}") : []
  end

  def link
    "/#{self.id}"
  end

  def image_name
    "/gallery/#{id}.jpg"
  end

  def legacy_gallery_path
    hasimage ? "/images#{image_name}" : "/images/noimage.jpg"
  end

  private
  def set_format
    self.format ||= FORMATS_BY_SIZE.keys.detect do |format|
      FORMATS_BY_SIZE[format].include?(size)
    end
  end

  def set_genre
    self.genre ||= Genre.find_by_ebay_genre(genrename)
  end

  def destroy_image
    remove_gallery_image!
  end

  def save_gallery_image
    if galleryimg
      self.remote_gallery_image_url = galleryimg
      self.hasimage = true
      save!
    end
  end

end
