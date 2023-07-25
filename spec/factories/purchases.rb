FactoryBot.define do
  factory :purchase do
    ticket { association(:ticket) }
    customer { association(:customer) }
    quantity { Faker::Number.between(from: 1, to: 10) }
    status { "pending"}
    purchase_total { ticket.price * quantity }
  end
end