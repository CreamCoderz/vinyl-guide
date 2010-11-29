require File.dirname(__FILE__) + '/../../lib/paginator/util'

class EbayItem < ActiveRecord::Base
  SEARCHABLE_FIELDS = ['title']
  DESC, ASC = 'desc', 'asc'

  validates_numericality_of :itemid, :only_integer => true
  validates_uniqueness_of :itemid
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :url

  belongs_to :release
  has_many :pictures, :foreign_key => "ebay_item_id"

  named_scope :singles, :conditions => ["size=? OR size=?", '7"', "Single (7-Inch)"]
  named_scope :eps, :conditions => ["size=? OR size=?", 'EP, Maxi (10, 12-Inch)', '10"']
  named_scope :lps, :conditions => ["size=? OR size=? OR size=?", "LP (12-Inch)", "LP", '12"']
  named_scope :other, :conditions => ["size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=? AND size!=?", "LP (12-Inch)", "LP", 'EP, Maxi (10, 12-Inch)', '10"', '7"', "Single (7-Inch)", '12"']

  cattr_reader :per_page
  @@per_page = 20

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

  def link
    "/#{self.id}"
  end

end