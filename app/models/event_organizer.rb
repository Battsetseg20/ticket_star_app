class EventOrganizer < ApplicationRecord
  belongs_to :user

   # has_many :events, dependent: :destroy

    # attribute :funds_received, :decimal, precision: 10, scale: 2
end
