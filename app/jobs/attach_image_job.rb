class AttachImageJob < ApplicationJob
  require 'open-uri'
  queue_as :default

  def perform(event_item_id, image_data)
    event_item = EventItem.find(event_item_id)
    
    image_file = Tempfile.new(['temp_image','.jpg'])
    image_file.binmode
    image_file.write URI.open(image_data).read
    image_file.rewind

    # Attach the image
    event_item.image.attach(io: File.open(image_file.path), filename: 'image.png')

    image_file.close
    image_file.unlink

    event_item.save!
  end
end
