Factory.define :label do |label|
 label.name { Factory.next(:name) }
 label.description { Factory.next(:description) }
end

Factory.define :label_with_release, :parent => :label do |label|
  label.after_create {|l| l.releases = [Factory(:release)] }
end

Factory.define :label_with_ebay_item, :parent => :label_with_release do |label|
  label.after_create {|l| l.releases.first.ebay_items = [Factory(:ebay_item)] }
end

Factory.sequence :name do |n|
  "label #{n}"
end

Factory.sequence :name do |n|
  "The legendary label #{n}. Livity."
end