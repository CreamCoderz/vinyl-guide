require 'pp'
require 'set'

class AddImageBools < ActiveRecord::Migration
  PICTURES_PATH = "/Users/will/vinylguide3/public/images/pictures"
  GALLERY_PATH = "/Users/will/vinylguide3/public/images/gallery"

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
    gallery_lookup_time = 0
    picture_lookup_time = 0
    insertion_time = 0
    EbayItem.find(:all).each do |ebay_item|
      ebay_item.hasimage = false
      begin_time = Time.new
      if gallery_filenames.include?("#{ebay_item.id}")
        ebay_item.hasimage = true
        gallery_img_count += 1
      end
      gallery_lookup_time += Time.new.to_i - begin_time.to_i
      i = 0
      ebay_item.pictures.each do |picture|
        picture.hasimage = false
        begin_time = Time.new
        if picture_filenames.include?("#{ebay_item.id}_#{i}")
          picture.hasimage = true
          i += 1
          picture_img_count +=1
        end
        picture_lookup_time += Time.new.to_i - begin_time.to_i
      end
      begin_time = Time.new
      ebay_item.save
      insertion_time += Time.new.to_i - begin_time.to_i
      if count % 100 == 0
        puts "id: #{ebay_item.id}"
      end
      count += 1
    end

    puts "gallery images found size: #{gallery_img_count}"
    puts "picture images found size: #{picture_img_count}"
    puts "lookup time gallery: #{gallery_lookup_time}"
    puts "lookup time pictures: #{picture_lookup_time}"
    puts "insertion time: #{insertion_time}"
  end

  def self.down
    remove_column(:ebay_items, :hasimage)
    remove_column(:pictures, :hasimage)
  end

end