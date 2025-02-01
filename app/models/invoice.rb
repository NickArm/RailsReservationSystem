class Invoice < ApplicationRecord
  belongs_to :booking
  belongs_to :customer

  enum :payment_status, { pending: 0, paid: 1, overdue: 2, canceled: 3 }

  validates :invoice_number, presence: true, uniqueness: true
  validates :total_amount, :tax_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_status, presence: true
  validates :vat_number, presence: true

  before_validation :assign_invoice_number, on: :create

  private

  def assign_invoice_number
    self.invoice_number ||= loop do
      number = "#{Time.zone.now.year}-#{SecureRandom.hex(4).upcase}"
      break number unless Invoice.exists?(invoice_number: number)
    end
  end
end
