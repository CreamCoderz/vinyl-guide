class AddGalleryImageToEbayItems < ActiveRecord::Migration
  def change
    add_column :ebay_items, :gallery_image, :string
    add_column :ebay_items, :slug, :string
    add_index :ebay_items, :slug, :unique => true
  end
end
