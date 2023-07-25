class Purchase < ApplicationRecord
  # Purchase model is where we will store the information about the purchases that customers make.
  # Customers will be able to purchase tickets for events.
  # EventOrganizer will be able to see the purchases that customers make for their events.
  # Status of the purchase will be pending, succeeded, or failed depending on the outcome of the purchase via Stripe.
  # Once purchase is succeeded, the quantity_available of the ticket will be reduced by the quantity of the purchase.
  # The ticket will be generated in pdf format and attached to the purchase.
  # The ticket will be sent to the customer via email.

  # Check the purchases_controller.rb for more details on how the purchase is created via Stripe API
  # and how the ticket is generated via TicketService.
  enum status: { pending: "pending", succeeded: "succeeded", failed: "failed" }, _prefix: :status

  # Associations
  belongs_to :customer
  belongs_to :ticket

  has_one_attached :ticket_pdf

  # Validations
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :purchase_total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  # Callbacks
  before_save :calculate_purchase_total


  def mark_as_succeeded!
    self.status = "succeeded"
    self.save!
  end

  def decrement_ticket_quantity!
    self.ticket.update!(quantity_available: ticket.quantity_available - quantity)
  end

  def attach_files(pdf_file_path)
    self.ticket_pdf.attach(io: File.open(pdf_file_path), filename: "ticket_#{ticket.event_item}_#{customer.user.lastname}.pdf")
  end

  private

  # Do I still need it?
  def calculate_purchase_total
    self.purchase_total = ticket.price * quantity
  end
end

