require File.dirname(__FILE__) + '/../util/paginator'

class EbayItem < ActiveRecord::Base
  SEARCHABLE_FIELDS = ['itemid', 'description', 'title', 'url', 'galleryimg', 'sellerid']
  ORDER_FIELDS = ['desc', 'asc']

  validates_numericality_of :itemid, :only_integer => true
  validates_numericality_of :price
  validates_numericality_of :bidcount
  validates_presence_of :url

  has_many :pictures, :foreign_key => "ebay_item_id"

  @@paginator = Paginator.new(EbayItem)

  def self.search(params)
    query_value, column = params[:query], params[:column]
    page_num, order = params[:page] || 1, params[:order] || ORDER_FIELDS[0]
    order_query = " #{column} #{order}"
    @ebay_items, @prev, @next, @start, @end, @total = @@paginator.paginate(page_num, [generate_query, {:wild_query => "%#{query_value}%"}], order_query)
  end

  private

  def self.generate_query
    query = ''
    SEARCHABLE_FIELDS.each do |searchable_field|
      query = append_or(query)
      query += "#{searchable_field} like :wild_query"
    end
    return query
  end

  def self.append_or(query_exp)
    query_exp.length > 0 ? query_exp += ' OR ' : query_exp
  end
end