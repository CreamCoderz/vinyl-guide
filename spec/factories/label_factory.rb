Factory.define :label do |label|
 label.name { Factory.next(:name) }
 label.description { Factory.next(:description) }
end

Factory.sequence :name do |n|
  "label #{n}"
end

Factory.sequence :name do |n|
  "The legendary label #{n}. Livity."
end