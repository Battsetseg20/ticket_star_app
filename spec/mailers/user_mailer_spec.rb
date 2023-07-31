require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#ticket_email" do
    let(:purchase) { FactoryBot.create(:purchase) }
    let(:mail) { UserMailer.with(purchase: purchase, pdf_file: "spec/fixtures/files/sample_ticket.pdf").ticket_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Your Ticket Purchase Confirmation")
      expect(mail.to).to eq([purchase.customer.user.email])
      expect(mail.from). to eq(["from@ticketstar.com"])
    end
  end
end
