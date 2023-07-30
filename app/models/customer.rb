class Customer < ApplicationRecord
  belongs_to :user

  has_many :purchases, dependent: :destroy

  # attribute :payment_method, :string
  # attribute :qr_code, :string

  def purchased_event_items
    return if purchases.blank?

    purchases.map(&:ticket).map(&:event_item).uniq
  end
end
