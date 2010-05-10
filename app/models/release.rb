class Release < ActiveRecord::Base
  has_many :ebay_items, :foreign_key => "release_id"

  validates_uniqueness_of :title, :scope => [:title, :artist, :year, :label, :matrix_number]
end
