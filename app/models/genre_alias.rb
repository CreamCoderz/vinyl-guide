class GenreAlias < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :genre_id

  validates_uniqueness_of :name

  belongs_to :genre
end