require File.dirname(__FILE__) + '/../../lib/query_generator'

class Release < ActiveRecord::Base
  SEARCHABLE_FIELDS = [:title, :artist, :label, :matrix_number]

  has_many :ebay_items, :foreign_key => "release_id", :order => "updated_at ASC"
  belongs_to :format
  #TODO: rename after we get rid of the label field
  belongs_to :label_entity, :class_name => 'Label', :foreign_key => 'label_id'

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label, :matrix_number, :format_id], :message => "must not match an existing combination of fields"

  validate_on_create :format_must_exist
  validate_on_update :format_must_exist

  @paginator = Paginator.new(Release)


  def self.search(params)
    query = QueryGenerator.generate_wild_query(SEARCHABLE_FIELDS, ':wild_query')
    page_num = params[:page] || 1
    @ebay_items, @prev, @next, @start, @end, @total = @paginator.paginate(page_num, [query, {:wild_query => "%#{params[:query]}%"}])
  end

  def link
    "/releases/#{id}"
  end

  private
  def format_must_exist
    unless Format.find_by_id(self.format_id)
      errors.add(:format, "the format must exist")
    end
  end
end
