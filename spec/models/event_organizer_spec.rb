require 'rails_helper'

RSpec.describe EventOrganizer, type: :model do
  subject { build(:event_organizer) }

  it { should belong_to(:user) }
  it { should have_many(:event_items).dependent(:destroy) }
end