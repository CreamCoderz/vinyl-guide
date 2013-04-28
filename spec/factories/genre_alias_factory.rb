Factory.define :genre_alias do |genre_alias|
  genre_alias.name { Factory.next(:name) }
  genre_alias.association :genre
end