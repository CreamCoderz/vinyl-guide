Factory.define :genre do |genre|
  genre.name { Factory.next(:name) }
end