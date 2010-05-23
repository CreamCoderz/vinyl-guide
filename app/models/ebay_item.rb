require File.dirname(__FILE__) + '/../../lib/paginator'
require File.dirname(__FILE__) + '/../../lib/query_generator'

class EbayItem < ActiveRecord::Base
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']
  DESC, ASC = 'desc', 'asc'

  validates_numericality_of :itemid, :only_integer => true
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :url

  has_many :pictures, :foreign_key => "ebay_item_id"

  @@paginator = Paginator.new(EbayItem)

  def self.search(params)
    query_value, column = params[:query], params[:column]
    page_num, order = params[:page] || 1, params[:order] || DESC
    order_query = " #{column} #{order}"
    query = QueryGenerator.generate_wild_query(SEARCHABLE_FIELDS, ':wild_query')
    @ebay_items, @prev, @next, @start, @end, @total = @@paginator.paginate(page_num, [query, {:wild_query => "%#{query_value}%"}], order_query)
  end

end