FactoryBot.define do
  factory :event_item do
    title { Faker::Book.title }
    description { Faker::Lorem.sentence }
    date { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
    time { Faker::Time.between(from: Time.now, to: 1.year.from_now, format: :default) }
    location { Faker::Address.full_address }
    status { EventItem.statuses.keys.sample }
    event_type { EventItem.event_types.keys.sample }
    event_organizer { association(:event_organizer) }
  end

  trait :with_image do
    after(:create) do |event_item|
      image_url = case event_item.event_type
      when 'literature'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['book'])
      when 'music'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['music'])
      when 'sports'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['sports'])
      when 'food'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['food'])
      when 'health'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['health'])
      when 'family'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['family'])
      when 'education'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['education'])
      when 'other'
        Faker::LoremFlickr.image(size: "300x300", search_terms: ['tourism'])
      end
      event_item.image.attach(io: URI.open(image_url), filename: 'image.png')
    end 
  end

  trait :with_ticket do
    after(:create) do |event_item|
      create(
        :ticket,
        price: Faker::Commerce.price(range: 10..100),
        quantity_available: Faker::Number.between(from: 1, to: 100),
        event_item: event_item)
    end
  end
end
