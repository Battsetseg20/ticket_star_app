require "rails_helper"

RSpec.describe EventItem, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      event_item = build(:event_item)
      expect(event_item).to be_valid
    end

    it "is not valid without a title" do
      event_item = build(:event_item, title: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:title]).to include("can't be blank")
    end

    it "is not valid without a description" do
      event_item = build(:event_item, description: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:description]).to include("can't be blank")
    end

    it "is not valid without a date" do
      event_item = build(:event_item, date: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:date]).to include("can't be blank")
    end

    it "is not valid without a time" do
      event_item = build(:event_item, time: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:time]).to include("can't be blank")
    end

    it "is not valid without a location" do
      event_item = build(:event_item, location: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:location]).to include("can't be blank")
    end

    it "is not valid without a status" do
      event_item = build(:event_item, status: nil)
      expect(event_item).not_to be_valid
      expect(event_item.errors[:status]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to an event organizer" do
      expect(EventItem.reflect_on_association(:event_organizer).macro).to eq(:belongs_to)
    end
  end
end
