Factory.define :user do |user|
  user.username { Factory.next(:username) }
  user.email { Factory.next(:email) }
  user.password { Factory.next(:password) }
end

Factory.define :confirmed_user, :parent => :user do |user|
  user.after_create { |user_created| user_created.confirm! }
end

Factory.sequence :email do |n|
  "email_addr#{n}@example.com"
end

Factory.sequence :username do |n|
  "jah_chicken_#{n}"
end

Factory.sequence :password do |n|
  "secret#{n}"
end