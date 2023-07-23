FactoryBot.define do
  factory :event_organizer do
    user { association(:user, password: '123456789') }
  end
end
  