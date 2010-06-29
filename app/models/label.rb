class Label < ActiveRecord::Base
  has_many :releases
  validates_uniqueness_of :name, :case_sensitive => false, :message => "The label name must be unique."
end
