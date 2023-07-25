require "rails_helper"

RSpec.describe PurchasesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:customer) { create(:customer) }
  let(:event_item) { create(:event_item) }
  let(:ticket) { create(:ticket, event_item: event_item, quantity_available: 100) }

  before do
    allow(Stripe::Checkout::Session).to receive(:create).and_return(double("Session", id: "cs_test_a1",
                                                                                      url: "https://checkout.stripe.com/c/pay/cs_test_a1"))
    sign_in customer.user
  end

  describe "POST #create" do
    context "when valid" do
      it "creates a new purchase" do
        expect do
          post :create, params: { ticket_id: ticket.id, quantity: 2 }
        end.to change(Purchase, :count).by(1)
      end

      it "redirects to the Stripe checkout session URL" do
        post :create, params: { ticket_id: ticket.id, quantity: 2 }
        expect(response).to redirect_to("https://checkout.stripe.com/c/pay/cs_test_a1")
      end
    end

    context "when invalid" do
      before do
        allow(Stripe::Checkout::Session).to receive(:create).and_raise(Stripe::InvalidRequestError.new("Message",
                                                                                                       "param"))
      end

      it "creates a new purchase" do
        expect do
          post :create, params: { ticket_id: ticket.id, quantity: 2 }
        end.to change(Purchase, :count).by(1)
      end

      it "sets the purchase status to failed" do
        post :create, params: { ticket_id: ticket.id, quantity: 2 }
        expect(Purchase.last.status).to eq("failed")
      end

      it "redirects to the event item page" do
        post :create, params: { ticket_id: ticket.id, quantity: 2 }
        expect(response).to redirect_to(event_items_path)
      end
    end
  end

  describe "GET #success" do
    let(:pending_purchase) { create(:purchase, status: "pending", quantity: 2, ticket: ticket, customer: customer) }

    before do
      allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(double("Session", payment_status: "paid",
                                                                                          metadata: { "purchase_id" => pending_purchase.id.to_s }))
      allow(UserMailer).to receive_message_chain(:with, :ticket_email, :deliver_later)
    end

    it "marks the purchase as succeeded" do
      expect do
        get :success, params: { session_id: "cs_test_a1" }
        pending_purchase.reload
      end.to change { pending_purchase.status }.from("pending").to("succeeded")
    end

    it "redirects to the purchase page" do
      get :success, params: { session_id: "cs_test_a1" }
      expect(response).to redirect_to(purchase_path(pending_purchase))
    end

    it "decreases the quantity_available of the ticket by the quantity of the purchase" do
      expect do
        get :success, params: { session_id: "cs_test_a1" }
        ticket.reload
      end.to change { ticket.quantity_available }.from(100).to(98)
    end

    it "generates a ticket in pdf format and attaches it to the purchase" do
      expect do
        get :success, params: { session_id: "cs_test_a1" }
        pending_purchase.reload
      end.to change { pending_purchase.ticket_pdf.attached? }.from(false).to(true)
    end

    it "sends the ticket to the customer via email" do
      expect(UserMailer).to receive_message_chain(:with, :ticket_email, :deliver_later)
      get :success, params: { session_id: "cs_test_a1" }
    end
  end
end
