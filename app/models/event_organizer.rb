class EventOrganizer < ApplicationRecord
  belongs_to :user

  has_many :event_items, dependent: :destroy

  # attribute :funds_received, :decimal, precision: 10, scale: 2
end
