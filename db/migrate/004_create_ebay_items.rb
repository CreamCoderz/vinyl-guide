class CreateEbayItems  < ActiveRecord::Migration

  def self.up
    create_table :ebay_items do |t|
      t.integer :itemid
      t.text :description
      t.integer :bidcount
      t.float :price
      t.time :endtime
      t.time :starttime
      t.string :url
      t.string :galleryimg
      t.string :sellerid
    end
  end

  def self.down
      drop_table :ebay_items
  end

end