# frozen_string_literal: true

class Review < ApplicationRecord
  # Review model is where we will store the information about the reviews that customers make for events.
  # Customers will be able to review events that they have purchased tickets for.
  belongs_to :event_item, foreign_key: "event_item_id", class_name: "EventItem"
  belongs_to :user

  validates :rating, inclusion: { in: 1..5 }
end
