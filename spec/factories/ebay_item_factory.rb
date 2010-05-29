Factory.define :ebay_item do |ebay_item|
  ebay_item.itemid { Factory.next(:itemid) }
  ebay_item.description { Factory.next(:description) }
  ebay_item.bidcount { Factory.next(:bidcount) }
  ebay_item.price { Factory.next(:price) }
  ebay_item.endtime { Factory.next(:endtime) }
  ebay_item.starttime { Factory.next(:starttime) }
  ebay_item.url { Factory.next(:url) }
  ebay_item.galleryimg nil
  ebay_item.sellerid { Factory.next(:sellerid) }
  ebay_item.title { Factory.next(:title) }
  ebay_item.size { Factory.next(:size) }
  ebay_item.speed { Factory.next(:speed) }
  ebay_item.condition { Factory.next(:condition) }
  ebay_item.subgenre { Factory.next(:subgenre) }
  ebay_item.country { Factory.next(:country) }
  ebay_item.currencytype "USD"
  ebay_item.hasimage false
  ebay_item.release_id nil
end

Factory.sequence :itemid do |n|
  n + 370384311537
end

Factory.sequence :description do |n|
  "this is the #{n}th description"
end

Factory.sequence :bidcount do |n|
  n + 1
end

Factory.sequence :price do |n|
  n + 20
end

Factory.sequence :endtime do |n|
  Date.new + n
end

Factory.sequence :starttime do |n|
  Date.new + n
end

Factory.sequence :url do |n|
  "http://www.example.com/#{n}"
end

Factory.sequence :sellerid do |n|
  "seller #{n}"
end

Factory.sequence :title do |n|
  "title #{n}"
end

Factory.sequence :size do |n|
  %{#{n}"}
end

Factory.sequence :speed do |n|
  n % 2 == 0 ? "45" : "33"
end

Factory.sequence :condition do |n|
  "#{n} condition"
end

Factory.sequence :subgenre do |n|
  n % 2 == 0 ? "roots" : "dub"
end

Factory.sequence :country do |n|
  "Jamaica #{n}"
end
