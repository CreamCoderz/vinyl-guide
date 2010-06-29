require File.dirname(__FILE__) + '/../../lib/query_generator'

class Release < ActiveRecord::Base
  SEARCHABLE_FIELDS = [:title, :artist, :matrix_number]

  has_many :ebay_items, :foreign_key => "release_id", :order => "updated_at ASC"
  belongs_to :format
  belongs_to :label_entity, :class_name => 'Label', :foreign_key => 'label_id'
  accepts_nested_attributes_for :label_entity

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label_id, :format_id, :matrix_number], :message => "The release must not match an existing combination of fields"

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
