class GalleryImageUploader < CarrierWave::Uploader::Base

  def default_url
    "/images/noimage.jpg"
  end

  def store_dir
    'gallery'
  end

  def filename
    if model.gallery_image.present?
      raise "Model slug not present for: #{model.inspect}" if model.slug.blank?
      model.slug
    end
  end
end
