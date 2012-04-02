Factory.define :favorite do |f|
  f.association :ebay_item
  f.association :user
end