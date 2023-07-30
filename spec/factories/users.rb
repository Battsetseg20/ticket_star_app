FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { "123456789"  } #Faker::Internet.unique.username(separators: %w(. _))
    username { Faker::Internet.unique.username(specifier: 6..12) }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65)  }
  end
end