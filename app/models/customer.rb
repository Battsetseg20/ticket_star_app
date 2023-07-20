class Customer < ApplicationRecord
  belongs_to :user

   # has_many :purchases, dependent: :destroy

   # attribute :payment_method, :string
  # attribute :qr_code, :string
end
