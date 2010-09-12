class Label < ActiveRecord::Base
  has_many :releases
  validates_uniqueness_of :name, :case_sensitive => false, :message => "The label name must be unique."

  def before_save
    self.name = self.name.strip    
  end

  def ebay_item
    releases.first.ebay_items.first unless releases.empty?
  end
end
