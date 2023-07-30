FactoryBot.define do
  factory :ticket do
    price { Faker::Commerce.price(range: 10..100) }
    quantity_available { 100 }
    event_item { association(:event_item) }
  end
end
