class Label < ActiveRecord::Base
  has_many :releases
  validates_uniqueness_of :name, :case_sensitive => false, :message => "The label name must be unique."

  before_save { self.name = self.name.strip }
  before_destroy :remove_releases

  def ebay_item
    releases.first.ebay_items.first unless releases.empty?
  end

  private
  def remove_releases
    releases.update_all(:label_id => nil)
  end
end
