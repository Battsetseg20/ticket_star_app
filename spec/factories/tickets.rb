FactoryBot.define do
  factory :ticket do
    price { Faker::Commerce.price(range: 10..100) }
    quantity_available { Faker::Number.between(from: 1, to: 10) }
    event_item { association(:event_item) }
  end
end
