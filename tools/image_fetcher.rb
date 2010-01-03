require 'activesupport'
require File.dirname(__FILE__) + '/../app/util/imageclient'
require File.dirname(__FILE__) + '/../app/util/webclient'

image_client = ImageClient.new(WebClient.new(Net::HTTP))
ebay_items = EbayItem.find(:all, :conditions => 'id > 9486')
#TODO: most recent fetched id: 35774
default_file = File.new(File.dirname(__FILE__) + "/../spec/data/default_ebay_img.jpg", "r")
default_file_contents = default_file.gets(nil)

def fetch_image(url, id, image_client)
  gallery_img_content = nil
  begin
    gallery_img_content = image_client.fetch(url)
  rescue Exception => e
    puts "id: #{id} url: #{url}"
    puts e
  end
  return gallery_img_content
end

ebay_items.each do |ebay_item|
  if ebay_item.galleryimg
    gallery_img_content = fetch_image(ebay_item.galleryimg, ebay_item.id, image_client)
    if gallery_img_content
      if default_file_contents != gallery_img_content
        f = File.new("/Users/will/Desktop/roots_imgs/gallery/#{ebay_item.id}.jpg", "w")
        f.syswrite(gallery_img_content)
      end
    end
  end
  i = 0
  ebay_item.pictures.each do |picture|
    gallery_img_content = fetch_image(picture.url, ebay_item.id, image_client)
    if gallery_img_content
      f = File.new("/Users/will/Desktop/roots_imgs/pictures/#{ebay_item.id}_#{i}.jpg", "w")
      f.syswrite(gallery_img_content)
      i += 1
    end
  end
end