class EventOrganizer < ApplicationRecord
  belongs_to :user

  has_many :event_items, dependent: :destroy
  
end
