class Picture < ActiveRecord::Base
  include ImageWriter
  include ImageClient

  belongs_to :ebay_item
  before_save :inject_image

  private

  def inject_image
    image_name = "/pictures/#{ebay_item.id}_#{num_pictures}.jpg"
    write_image(image_name, fetch(picture.url))
  end

end