class Picture < ActiveRecord::Base
  include ImageWriter
  include ImageClient

  belongs_to :ebay_item

  validates_presence_of :ebay_item

  before_create :inject_image
  after_create :save_image
  after_destroy :destroy_image

  mount_uploader :image, PictureImageUploader

  def image_name
    @image_name ||=
        (index = ebay_item.pictures.order('id asc').all.index(self) || ebay_item.reload.pictures.count
        "/pictures/#{ebay_item.id}_#{index}.jpg")
  end

  private

  # legacy image file handling
  def inject_image
    write_image(image_name, fetch(url))
  end

  def destroy_image
    delete_image(image_name)
  end

  def save_image
    self.image = read_image(image_name)
    save!
  end
end