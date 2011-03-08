class Release < ActiveRecord::Base
  SEARCHABLE_FIELDS = [:title, :artist, :matrix_number]
  VALID_YEARS = (1940..Time.new.year).to_a.reverse

  has_many :ebay_items, :foreign_key => "release_id", :order => "updated_at DESC"
  belongs_to :format
  belongs_to :label_entity, :class_name => 'Label', :foreign_key => 'label_id', :dependent => :destroy
  accepts_nested_attributes_for :label_entity

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label_id, :format_id, :matrix_number], :message => "The release must not match an existing combination of fields"

  validate_on_create :format_must_exist, :year_must_be_valid
  validate_on_update :format_must_exist

  searchable do
    string :title
    string :artist
    string :matrix_number
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

  def year_must_be_valid
    if self.year && !VALID_YEARS.include?(self.year)
      errors.add(:year, "the year must have 4 digits and be valid")
    end
  end
end
