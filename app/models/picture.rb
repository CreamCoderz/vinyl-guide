class Picture < ActiveRecord::Base
  belongs_to :ebay_item

  validates_presence_of :ebay_item

  after_create :save_image
  after_destroy :destroy_image

  mount_uploader :image, PictureImageUploader

  private

  def destroy_image
    remove_image!
  end

  def save_image
    self.remote_image_url = url
    save!
  rescue Timeout::Error => e
    p "Timeout fetching image.. #{url}"
    false
  end
end