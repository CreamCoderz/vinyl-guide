Factory.define :comment do |comment|
  comment.body 'le body'
  comment.title 'le title'
  comment.user { Factory(:confirmed_user) }
  comment.parent { Factory(:ebay_item) }
end
