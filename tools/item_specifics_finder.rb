require 'activesupport'

RECORDSIZE = 'size'
SUBGENRE = 'subgenre'
CONDITION = 'condition'
SPEED = 'speed'
COUNTRY = 'country'

item_specifics = {RECORDSIZE => [], SUBGENRE => [], CONDITION => [], SPEED => []}

ebay_items = EbayItem.find(:all)

ebay_items.each do |ebay_item|
  item_specifics.each_key do |key|
    item_specifics[key] = item_specifics[key].concat([ebay_item[key]])
  end
end

item_specifics.each do |key, values|
  puts "#{key}:\n"
  values.uniq!
  values.each do |value|
   puts "#{value}\n"
  end
  puts "-------------------"
end