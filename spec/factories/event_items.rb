FactoryBot.define do
  factory :event_item do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    date { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
    time { Faker::Time.between(from: Time.now, to: 1.year.from_now, format: :default) }
    location { Faker::Address.full_address }
    status { EventItem.statuses.keys.sample }
    event_organizer { association(:event_organizer) }

    trait :with_ticket do
      after(:create) do |event_item|
        create(
          :ticket,
          price: Faker::Commerce.price(range: 10..100),
          quantity_available: Faker::Number.between(from: 1, to: 10),
          event_item: event_item)
      end
    end
  end
end
