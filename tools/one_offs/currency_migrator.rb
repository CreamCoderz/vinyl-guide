#This script was created refetch all ebay items of a non-us currency type and store their currency in USD
# USD will be the canonical currency going forward
require File.dirname(__FILE__) + '/../../app/util/ebay/ebayclient'
require File.dirname(__FILE__) + '/../../app/util/ebay/ebaycrawler'
require File.dirname(__FILE__) + '/../../app/util/ebay/../webclient'
require File.dirname(__FILE__) + '/../../app/util/ebay/../imageclient'
require File.dirname(__FILE__) + '/../../app/util/ebay/../dateutil'

ebay_items = EbayItem.find(:all, :conditions => "currencytype != 'USD'")

puts "found: #{ebay_items.length} items"

web_client = WebClient.new(Net::HTTP)

ebay_client = EbayClient.new(web_client, "USE-A-VALID-API-KEY")

item_ids = ebay_items.map{|ebay_item|ebay_item.itemid}
ebay_item_data = ebay_client.get_details(item_ids)

puts "found: #{ebay_item_data.length} ebay item datas"

#ebay_item_data.each do |item_data|
#  ebay_item = EbayItem.find(:first, :conditions => {:itemid => item_data.itemid})
#  ebay_item.currencytype = item_data.currencytype
#  ebay_item.price = item_data.price
#  unless ebay_item.save
#    puts "couldn't save ebay item id: #{ebay_item.itemid} with app id #{ebay_item.id}"
#  end
#end