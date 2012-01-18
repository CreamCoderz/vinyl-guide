class ImageInjector

  def inject_images(ebay_item)
    num_pictures = 0
    num_gallery = 0
    ebay_item.pictures.each do |picture|
      image_name = "/pictures/#{ebay_item.id}_#{num_pictures}.jpg"
      if write_image(image_name, @image_client.fetch(picture.url))
        num_pictures += 1
        #TODO: test this
        picture.hasimage = true
        picture.save
      end
    end
    if ebay_item.galleryimg and write_image("/gallery/#{ebay_item.id}.jpg", @image_client.fetch(ebay_item.galleryimg))
      num_gallery += 1
      #TODO: test this
      ebay_item.hasimage = true
      ebay_item.save
    end
    return [num_pictures, num_gallery]
  end

  private

  def write_image(image_name, image_content)
    if (verify_image(image_content))
      f = File.new(VinylGuide::STORAGE_DIR.path + image_name, "w")
      f.syswrite(image_content)
      return true
    end
    return false
  end

  def verify_image(image_content)
    verified = true
    if (image_content)
      verified = !(DEFAULT_EBAY_IMAGE == image_content)
    else
      verified = false
    end
    verified
  end
end