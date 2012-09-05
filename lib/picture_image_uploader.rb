class PictureImageUploader < CarrierWave::Uploader::Base

  def default_url
    "/images/noimage.jpg"
  end

  def store_dir
    'pictures'
  end

  def filename
    # really should be checking the property names in the :mount_uploader call in the model
    if model.image.present?
      ebay_item = model.ebay_item
      raise "ebay_item.slug not present for: #{ebay_item.inspect}" if ebay_item.slug.blank?
      raise "Model id not present for: #{model.inspect}" if model.id.blank?
      "#{ebay_item.slug}_#{model.id}"
    end
  end
end
