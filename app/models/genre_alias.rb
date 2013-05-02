class GenreAlias < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :genre_id

  validates_uniqueness_of :name

  belongs_to :genre

  after_create :update_ebay_items

  private

  def update_ebay_items
    EbayItem.where(:genrename => name).update_all(["genre_id = ?", genre_id])
    true
  end
end