require File.dirname(__FILE__) + '/../../lib/paginator'
require File.dirname(__FILE__) + '/../../lib/query_generator'

class Release < ActiveRecord::Base
  SEARCHABLE_FIELDS = [:title, :artist, :label, :matrix_number]

  has_many :ebay_items, :foreign_key => "release_id"

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label, :matrix_number], :message => "must not match an existing combination of fields"

  @@paginator = Paginator.new(Release)

  def self.search(params)
    query = QueryGenerator.generate_wild_query(SEARCHABLE_FIELDS, ':wild_query')
    @ebay_items, @prev, @next, @start, @end, @total = @@paginator.paginate(1, [query, {:wild_query => "%#{params[:query]}%"}])

  end
end
