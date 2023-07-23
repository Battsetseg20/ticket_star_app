FactoryBot.define do
  factory :customer do
    user { association(:user, password: '123456789') }
  end
end