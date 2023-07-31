# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
include ImageHelper

ActiveRecord::Base.transaction do
  puts 'Creating event items...'
  60.times do
    FactoryBot.create(:event_item, :with_ticket)
  end
  puts EventItem.count.to_s + " event items created along with users, event organizers, tickets"
  
  puts 'Attaching images to event items...'
  count = 0
  EventItem.all.each do |event_item|
    search_term = case event_item.event_type
    when 'literature'
      'book'
    when 'music'
      'singer'
    when 'sports'
      'sports'
    when 'food'
      'food'
    when 'health'
      'health'
    when 'family'
      'family'
    when 'education'
      'education'
    else
      'tourism'
    end

    begin
      # Get the image URL
      image_url = Faker::LoremFlickr.image(size: "300x300", search_terms: [search_term])
      image_data = fetch_image(image_url)
      puts "Image fetched from #{image_data}"
  
      AttachImageJob.perform_later(event_item.id, image_data)

      puts "Image attached? #{event_item.image.attached?}"
  
      puts "Image attached to #{event_item.title} + #{event_item.id} + count #{count += 1}"
    end
  end

  puts 'Creating purchases...'
  100.times do
    begin
      # Select a random ticket from existing event_items.
      ticket = EventItem.all.sample.ticket

      # Create a new purchase with the selected ticket and an associated customer.
      purchase = FactoryBot.create(:purchase, ticket: ticket, status: Purchase.statuses.keys.sample ) 
      next if ticket.quantity_available < purchase.quantity

      puts 'Attaching pdf tickets to purchases...'
      TicketService.generate_ticket_pdf(purchase)

      # Decrement the quantity_available of the ticket by the quantity of the purchase.
      ticket.quantity_available -= purchase.quantity
      ticket.save!

      # Update the event_item status to 'sold_out' if no more tickets are available.
      if ticket.quantity_available.zero?
        event_item = ticket.event_item
        event_item.status = 'sold_out'
        event_item.save!
      end

    rescue StandardError => e
      puts "An error occurred while creating a purchase, attaching a PDF, and updating ticket and event item: #{e.message}"
      raise ActiveRecord::Rollback
    end
  end
end
