require File.dirname(__FILE__) + '/../../lib/query_generator'

class Release < ActiveRecord::Base
  SEARCHABLE_FIELDS = [:title, :artist, :matrix_number]
  VALID_YEARS = (1940..Time.now.year).to_a.reverse

  has_many :ebay_items, :order => "updated_at DESC"
  belongs_to :format
  belongs_to :label_entity, :class_name => 'Label', :foreign_key => 'label_id'
  accepts_nested_attributes_for :label_entity

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label_id, :format_id, :matrix_number], :message => "The release must not match an existing combination of fields"

  validate :format_must_exist, :year_must_be_valid

  @paginator = Paginator::Util.new(Release)

  before_validation :set_label

  def self.search(params)
    query = QueryGenerator.generate_wild_query(SEARCHABLE_FIELDS, ':wild_query')
    page_num = params[:page] || 1
    @paginator.paginate(page_num, [query, {:wild_query => "%#{params[:query]}%"}])
  end

# TODO: make this work with wildcard solr searches
#  searchable do
#    string :title
#    string :artist
#    string :matrix_number
#  end

  def ebay_item
    ebay_items.first
  end

  def link
    "/releases/#{id}"
  end

  private
  def set_label
    if self.label_entity
      existing_label = Label.find_by_name(label_entity.name)
      self.label_entity = existing_label ? existing_label : Label.new(:name => label_entity.name)
    end
  end

  def format_must_exist
    unless Format.find_by_id(self.format_id)
      errors.add(:format, "the format must exist")
    end
  end

  def year_must_be_valid
    if self.year && !VALID_YEARS.include?(self.year)
      errors.add(:year, "the year must have 4 digits and be valid")
    end
  end
end
