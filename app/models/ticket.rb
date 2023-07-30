class Ticket < ApplicationRecord
  # Ticket model is where we will store the information about the tickets that are available for purchase.
  # EventOrganizer will be able to create tickets for their events.
  # Customers will be able to purchase tickets for events.
  belongs_to :event_item, foreign_key: "event_item_id", class_name: "EventItem", inverse_of: :ticket
  has_many :purchases, dependent: :destroy

  # Validations
  validates :event_item, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def sold_out?
    quantity_available.zero?
  end
end
