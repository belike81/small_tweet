Factory.define :user do |user|
  user.name 'test'
  user.email 'test@new.com'
  user.password 'testing'
  user.password_confirmation 'testing'
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :post do |post|
  post.content 'foobar'
  post.association :user
end
