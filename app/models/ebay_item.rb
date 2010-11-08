require File.dirname(__FILE__) + '/../../lib/paginator/util'
require File.dirname(__FILE__) + '/../../lib/query_generator'

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

  @paginator = Paginator::Util.new(EbayItem)

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