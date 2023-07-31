class Customer < ApplicationRecord
  belongs_to :user

  has_many :purchases, dependent: :destroy

  def purchased_event_items
    return if purchases.blank?

    purchases.map(&:ticket).map(&:event_item).uniq
  end
end
