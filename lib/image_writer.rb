module ImageWriter
  DEFAULT_EBAY_IMAGE = File.new("#{Rails.root}/lib/crawler/data/default_ebay_img.jpg").gets(nil)

  def write_image(image_name, image_content)
    if verified = verify_image(image_content)
      f = File.new(@image_dir.path + image_name, "w")
      f.syswrite(image_content)
    end
    verified
  end

  def verify_image(image_content)
    image_content.present? && DEFAULT_EBAY_IMAGE != image_content
  end
end