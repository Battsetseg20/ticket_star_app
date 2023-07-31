# frozen_string_literal: true

class EventItem < ApplicationRecord
  # EventItem model is for the event organizer to create an event and to manage the event and its tickets
  # EventItem model is for the customer to view the event and to purchase the ticket
  enum status: { draft: 0, published: 1, cancelled: 2, sold_out: 3, completed: 4 }
  enum event_type: { literature: 0, music: 1, sports: 2, food: 3, health: 5, family: 6, education: 7, other: 8 }

  belongs_to :event_organizer

  has_one_attached :image
  validates :image, content_type: ["image/png", "image/jpg", "image/jpeg"], size: { less_than: 1.megabytes }

  has_one :ticket, dependent: :destroy, inverse_of: :event_item
  has_many :purchases, through: :ticket # has_one ticket!!!

  accepts_nested_attributes_for :ticket, allow_destroy: true

  validates_presence_of :title, :date, :time, :location, :description, :status
  validate :date_not_in_the_past

  before_save :set_default_status, if: :new_record?

  # scopes
  EventItem.event_types.each_key do |event_type|
    scope event_type, -> { published.where(event_type: event_type) }
  end
  scope :latest_events, -> { published.where("date >= ?", Date.today).order(date: :asc).limit(5) }
  scope :hot_events, lambda {
    published.joins(:ticket)
             .select("event_items.*, tickets.quantity_available AS ticket_quantity_available")
             .order("ticket_quantity_available DESC")
             .limit(5)
  }
  scope :sold_out, -> { published.joins(:ticket).where("tickets.quantity_available = ?", 0) }
  scope :past_events, -> { completed.where("date < ?", Date.today) }
  scope :present_events, -> { published.where("date >= ?", Date.today) }
  scope :has_purchases, -> { joins(:purchases).distinct }

  def has_succeeded_purchases?
    ticket.purchases.where(status: "succeeded").exists?
  end

  def past_event?
    date < Date.today
  end

  private

  def set_default_status
    self.status ||= :draft
  end

  def date_not_in_the_past
    return unless date.present? && date < Date.today

    errors.add(:date, "cannot be in the past")
  end

  def set_status_to_completed!
    return if past_event? || status != "completed"

    update!(status: :completed)
  end
end
