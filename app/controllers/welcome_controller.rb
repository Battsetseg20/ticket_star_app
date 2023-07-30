# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @event_items = EventItem.present_events.order(date: :desc).group_by(&:event_type)
    fixed_order = EventItem.event_types.keys
    @event_items = @event_items.sort_by { |key, _| fixed_order.index(key) }.to_h

    # Take the last 4 event items for the welcome board cards
    @event_items = @event_items.transform_values { |event_items| event_items.last(4) }

  end

  def disclaimer; end
end
