FactoryBot.define do
  factory :user do
    username { "Default User" }
    email { "example_user@gmail.com" }
    zipcode { "73837" }
  end
end
