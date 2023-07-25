class EventItem < ApplicationRecord
  # EventItem model is for the event organizer to create an event and to manage the event and its tickets
  # EventItem model is for the customer to view the event and to purchase the ticket
  enum status: { draft: 0, published: 1, cancelled: 2, sold_out: 3, completed: 4 }, _prefix: :status

  belongs_to :event_organizer

  has_one :ticket, dependent: :destroy, inverse_of: :event_item
  has_many :purchases, through: :tickets

  accepts_nested_attributes_for :ticket, allow_destroy: true

  validates_presence_of :title, :date, :time, :location, :description, :status
  validate :date_not_in_the_past

  before_save :set_default_status, if: :new_record?
 
  private

  def set_default_status
    self.status ||= :draft
  end

  def date_not_in_the_past
    return unless date.present? && date < Date.today

    errors.add(:date, "cannot be in the past")
  end
end
