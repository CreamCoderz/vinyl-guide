class Picture < ActiveRecord::Base
  include ImageWriter
  include ImageClient

  belongs_to :ebay_item
  before_create :inject_image
  after_destroy :destory_image

  def image_name
    "/pictures/#{ebay_item.id}_#{ebay_item.reload.pictures.count}.jpg"
  end

  private

  def inject_image
    write_image(image_name, fetch(url))
  end

  def destroy_image
    delete_image(image_name)
  end

end