class Format < ActiveRecord::Base

  LP = Format.find_by_name('LP')
  EP = Format.find_by_name('EP')
  SINGLE = Format.find_by_name('Single')

  has_many :releases

  validates_uniqueness_of :name, :message => "The name must be unique"
end
