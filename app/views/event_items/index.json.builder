json.array! @event_items do |event_item|
    json.id event_item.id
    json.title event_item.title
    json.description event_item.description
    json.date event_item.date
    json.time event_item.time
    json.location event_item.location
    json.status event_item.status
  end
  