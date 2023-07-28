class TicketService
  def self.generate_ticket_pdf(purchase)
    # Check that purchase and its related objects are not nil
    return nil unless purchase&.ticket && purchase.ticket.event_item && purchase&.customer && purchase.customer.user

    pdf = Prawn::Document.new

    # Generate data string for QR code
    qr_code_data = {
      ticket_id: purchase.id,
      user_name: purchase.customer.user.lastname,
      event_title: purchase.ticket.event_item.title,
      quantity: purchase.quantity,
      date: purchase.ticket.event_item.date,
      location: purchase.ticket.event_item.location
    }.to_json

    begin
      # Generate QR code
      qr_code = RQRCode::QRCode.new(qr_code_data)
    rescue RQRCode::DataTooLarge
      return nil
    end

    qr_code_image = qr_code.as_png(size: 200)

    # Save the QR code image temporarily
    qr_code_file_path = "#{Rails.root}/tmp/qr_code_#{purchase.ticket.event_item}_#{purchase.customer.user.lastname}.png"

    File.open(qr_code_file_path, "wb") do |file|
      file.write(qr_code_image.to_s)
    end

    # Place the ticket information and the qr code image into the PDF
    pdf.bounding_box([0, pdf.cursor], width: 270) do
      pdf.text "Ticket ID: #{purchase.id}"
      pdf.text "Event: #{purchase.ticket.event_item.title}"
      pdf.text "Date: #{purchase.ticket.event_item.date}"
      pdf.text "Time: #{purchase.ticket.event_item.time}"
      pdf.text "Quantity: #{purchase.quantity}"
      pdf.text "Total: $#{format('%.2f', purchase.purchase_total)}"
    end

    pdf.bounding_box([300, pdf.bounds.top], width: 270) do
      pdf.image qr_code_file_path
    end

    # Save the PDF file
    pdf_file_path = "#{Rails.root}/tmp/ticket_#{purchase.id}.pdf"

    begin
      pdf.render_file pdf_file_path
    rescue Prawn::Errors::CannotFit
      return nil
    end

    # Cleanup QR code file after embedding it into the PDF
    File.delete(qr_code_file_path) if File.exist?(qr_code_file_path)

    pdf_file_path
  end
end
