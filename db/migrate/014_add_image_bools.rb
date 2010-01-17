require 'pp'
require 'set'

class AddImageBools < ActiveRecord::Migration
  PICTURES_PATH = "/Users/will/Desktop/roots_imgs/pictures"
  GALLERY_PATH = "/Users/will/Desktop/roots_imgs/gallery"

  def self.up
    add_column(:ebay_items, :hasimage, :boolean)
    add_column(:pictures, :hasimage, :boolean)
    picture_filenames = Dir.entries(PICTURES_PATH).map{|filename| filename.split(".")[0]}.to_set
    gallery_filenames = Dir.entries(GALLERY_PATH).map{|filename| filename.split(".")[0]}.to_set

    puts "gallery size: #{gallery_filenames.length}"
    puts "picture size: #{picture_filenames.length}"

    gallery_img_count = 0
    picture_img_count = 0

    count = 0
    EbayItem.find(:all).each do |ebay_item|
      ebay_item.hasimage = false
      if gallery_filenames.include?("#{ebay_item.id}")
        ebay_item.hasimage = true
        gallery_img_count += 1
      end
      i = 0
      ebay_item.pictures.each do |picture|
        picture.hasimage = false
        if picture_filenames.include?("#{ebay_item.id}_#{i}")
          picture.hasimage = true
          i += 1
          picture_img_count +=1
        end
      end
      ebay_item.save
      if count % 100 == 0
        puts "id: #{ebay_item.id}"
      end
      count += 1
    end

    puts "gallery images found size: #{gallery_img_count}"
    puts "picture images found size: #{picture_img_count}"

  end

  def self.down
    remove_column(:ebay_items, :hasimage)
    remove_column(:pictures, :hasimage)
  end

end