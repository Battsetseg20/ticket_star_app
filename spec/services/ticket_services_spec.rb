require "rails_helper"
require 'pdf-reader'

RSpec.describe TicketService do
  describe ".generate_ticket_pdf" do
    context "when purchase and related objects are present" do
      let(:user) { create(:user, lastname: 'Doe', password: '123456789') }
      let(:customer) { create(:customer, user: user) }
      let(:event_item) { create(:event_item, title: 'Sample Event', date: '2024-01-01', location: 'Venue A') }
      let(:ticket) { create(:ticket, event_item: event_item) }
      let(:purchase) { create(:purchase, ticket: ticket, customer: customer, quantity: 2, purchase_total: 100) }

      it "generates a ticket PDF" do
        pdf_file_path = TicketService.generate_ticket_pdf(purchase)

        expect(pdf_file_path).to be_present
        expect(File.exist?(pdf_file_path)).to be_truthy
      end

      it "generates a ticket PDF with the correct information" do
        pdf_file_path = TicketService.generate_ticket_pdf(purchase)
        pdf_reader = PDF::Reader.new(pdf_file_path)
        content = pdf_reader.pages.map(&:text).join

        lines = content.split("\n")

        expect(lines[0]).to include("Ticket ID: #{purchase.id}")
        expect(lines[1]).to include("Event: #{purchase.ticket.event_item.title}")
        expect(lines[2]).to include("Date: #{purchase.ticket.event_item.date}")
        expect(lines[3]).to include("Time: #{purchase.ticket.event_item.time}")
        expect(lines[4]).to include("Quantity: #{purchase.quantity}")
        expect(lines[5]).to include("Total: $#{format('%.2f', purchase.purchase_total)}")
      end
    end

    context "when purchase or related objects are nil" do
      it "returns nil" do
        expect(TicketService.generate_ticket_pdf(nil)).to be_nil
      end
    end
  end
end
