require File.dirname(__FILE__) + '/../util/paginator'

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
    @ebay_items, @prev, @next, @start, @end, @total = @@paginator.paginate(page_num, [generate_query, {:wild_query => "%#{query_value}%"}], order_query)
  end

  private

  def self.generate_query
    query = ''
    SEARCHABLE_FIELDS.each do |searchable_field|
      query += " OR " unless query.blank?
      query += "#{searchable_field} like :wild_query"
    end
    return query
  end
end