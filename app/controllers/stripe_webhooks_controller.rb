# frozen_string_literal: true

# For asynchronous payment confirmation, Stripe sends a POST request to the webhook endpoint
class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SIGNING_SECRET"]
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      log_error("Invalid payload", e)
      render status: 400, json: { error: "Invalid payload" }
      return
    rescue Stripe::SignatureVerificationError => e
      log_error("Invalid signature", e)
      render status: 400, json: { error: "Invalid signature" }
      return
    end

    # Handle different event types
    case event.type
    when "checkout.session.completed"
      handle_checkout_session_completed(event.data.object)
    else
      log_info("Received unhandled event type: #{event.type}")
      render status: 200, json: { received: true }
    end
  end

  private

  def handle_checkout_session_completed(session)
    purchase = Purchase.find_by(id: session.metadata.purchase_id)

    # Check if the purchase exists and if it is in 'pending' status
    if purchase&.status == "pending" && session.payment_status == "paid"
      ticket = purchase.ticket
      event_item = ticket.event_item

      # Update ticket and event_item quantities
      remaining_quantity = ticket.quantity_available - purchase.quantity
      ticket.update(quantity_available: remaining_quantity)

      if remaining_quantity.zero?
        # Update event_item status if ticket is sold out
        event_item.update(status: "sold_out")
      end

      # Generate ticket PDF and attach it to the purchase
      ticket_pdf_path = TicketService.generate_ticket_pdf(purchase)
      purchase.attach_files(ticket_pdf_path)

      # Mark the purchase as 'succeeded'
      purchase.update(status: "succeeded")
    end

    render status: 200, json: { received: true }
  end

  def log_error(message, error)
    Rails.logger.error("#{message}: #{error.message}")
  end

  def log_info(message)
    Rails.logger.info(message)
  end
end
