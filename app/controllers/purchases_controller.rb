# frozen_string_literal: true

class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.customer?
      @purchases = current_user.customer.purchases
    elsif current_user.organizer?
      @purchases = current_user.event_items.map(&:purchases).flatten
    end
  end

  def show
    @purchase = Purchase.find(params[:id])
  end

  def create
    @ticket = Ticket.find(params[:ticket_id])
    @event_item = @ticket.event_item
    # raise if @event_item.sold_out? || @event_item.past_event?
    @quantity = params[:quantity].to_i
    @amount = @ticket.price * @quantity

    # Create purchase with "pending" status
    @purchase = Purchase.create(
      customer: current_user.customer,
      ticket: @ticket,
      quantity: @quantity,
      purchase_total: @amount,
      status: "pending"
    )

    # Create Stripe checkout session, which will redirect user to Stripe-hosted payment page
    # so that they can enter their payment information
    # See https://stripe.com/docs/payments/checkout/accept-a-payment#create-checkout-session
    # for more details
    # Stripe webhook will be used to retrieve the payment status after the user has completed the payment
    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items: [{
        price_data: {
          currency: "usd",
          product_data: {
            name: @event_item.title
          },
          unit_amount: (@ticket.price * 100).to_i
        },
        quantity: @quantity
      }],
      mode: "payment",
      success_url: "#{success_purchases_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_purchases_url,
      metadata: {
        user_id: current_user.id,
        ticket_id: @ticket.id,
        quantity: @quantity,
        amount: @amount,
        purchase_id: @purchase.id
      }
    )

    redirect_to session.url, allow_other_host: true
  rescue Stripe::InvalidRequestError => e
    @purchase.update!(status: "failed")
    flash[:error] = e.message
    redirect_to event_items_path
  end

  def success
    # Retreive the session id to retrieve the session object from Stripe
    @session_id = params[:session_id]
    @session = Stripe::Checkout::Session.retrieve(@session_id)
    @purchase = Purchase.find(@session.metadata["purchase_id"])

    if @session.payment_status == "paid"
      # Update the purchase status to "succeeded" if the payment status is "paid"
      @purchase.mark_as_succeeded!
      # Decrease the quantity_available of the ticket by the quantity of the purchase
      @purchase.decrement_ticket_quantity!
      # Generate the ticket in pdf format and attach it to the purchase
      pdf_file = TicketService.generate_ticket_pdf(@purchase)
      @purchase.attach_files(pdf_file)

      # Send the ticket to the customer via email
      UserMailer.with(purchase: @purchase, pdf_file: pdf_file).ticket_email.deliver_later

      redirect_to purchase_path(@purchase)
    else
      flash[:alert] =
        "We are not able to confirm your payment at the moment. Please come back later to check the status of your purchase."
      redirect_to buy_tickets_purchases_path(ticket_id: @session.metadata.ticket_id)
    end
  rescue Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => e
    flash[:error] = "We are not able to process your payment at the moment. Please try again. #{e.message}"
    redirect_to event_items_path
  end
end
