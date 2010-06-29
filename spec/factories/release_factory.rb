Factory.define :release do |release|
  release.title { Factory.next(:title) }
  release.artist { Factory.next(:artist) }
  release.year { Factory.next(:year) }
  release.label_entity { Factory.next(:label) }
  release.format Format::LP
  release.matrix_number { Factory.next(:matrix_number) }
end

Factory.sequence :title do |n|
  "title #{n}"
end

Factory.sequence :artist do |n|
  "artist #{n}"
end

Factory.sequence :year do |n|
  1970 + n
end

Factory.sequence :label do |n|
  Factory(:label)
end

Factory.sequence :matrix_number do |n|
  "KLP-00#{n}"
end
