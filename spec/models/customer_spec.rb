require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { build(:customer) }

  it { should belong_to(:user) }
  it { should have_many(:purchases).dependent(:destroy) }

  describe '#purchased_event_items' do
    it 'returns nil if no purchases' do
      expect(subject.purchased_event_items).to be_nil
    end

    it 'returns the event items purchased by the customer' do
      event_item = create(:event_item)
      ticket = create(:ticket, event_item: event_item)
      purchase = create(:purchase, ticket: ticket, customer: subject)

      expect(subject.purchased_event_items).to eq([event_item])
    end
  end
end