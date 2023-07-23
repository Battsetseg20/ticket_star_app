FactoryBot.define do
  factory :event_item do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    date { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
    time { Faker::Time.between(from: Time.now, to: 1.year.from_now, format: :default) }
    location { Faker::Address.full_address }
    status { EventItem.statuses.keys.sample }
    event_organizer { association(:event_organizer) }
  end
end
