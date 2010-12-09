require 'pp'

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
  puts "-------------------"
  grouped_specifics = {}
  values.each do |value|
    if grouped_specifics.has_key?(value)
      grouped_specifics[value] = grouped_specifics[value] += 1
    else
      grouped_specifics[value] = 1
    end
  end
  grouped_specifics = grouped_specifics.sort {|a,b| b[1]<=>a[1]}
  pp grouped_specifics
  puts "-------------------"
end