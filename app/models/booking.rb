class Booking < ApplicationRecord
  # Associations
  belongs_to :customer
  belongs_to :property
  belongs_to :payment_method, optional: false
  has_many :invoices, dependent: :destroy

  # Enum for status
  enum :status, { unpaid: 0, confirm_payment: 1, paid: 2, canceled: 3 }

  accepts_nested_attributes_for :customer

  # Before Validations
  before_validation :generate_unique_code, on: :create

  # Validations
  validates :start_date, :end_date, presence: true
  validate :validate_stay_length
  validate :validate_dates
  validates :status, presence: true

  # Callbacks
  before_destroy :ensure_canceled_status

  # Delegations
  delegate :name, to: :customer, prefix: true, allow_nil: true

  # Create Invoice after successful payment
  # aafter_update :generate_invoice, if: -> { saved_change_to_status? && status == 'paid' }

  # Custom Getter and Setter for Reservation Status
  def reservation_status
    ReservationStatus.find_by(id: status) || super
  end

  def reservation_status=(name)
    status_obj = ReservationStatus.find_by(name: name)
    self.status = status_obj.id if status_obj.present?
  end

  # #For invoices
  # def generate_invoice
  #   Rails.logger.debug "Generating invoice for Booking ##{id}"
  #   Rails.logger.debug "Customer: #{customer.inspect}"
  #   Rails.logger.debug "Invoice Number: #{generate_invoice_number}"
  #   Rails.logger.debug "Total Amount: #{total_price}"
  #   Rails.logger.debug "Tax Amount: #{calculate_tax_amount}"

  #   Invoice.create!(
  #     booking: self,
  #     customer: customer,
  #     invoice_number: generate_invoice_number,
  #     total_amount: total_price,
  #     tax_amount: calculate_tax_amount,
  #     issued_date: Time.zone.now,
  #     due_date: Time.zone.now + 7.days,
  #     payment_status: :pending,
  #     vat_number: customer.vat_number || 'DEFAULT_VAT' # Replace with a default value or proper logic
  #   )
  # end

  # def generate_invoice_number
  #   "#{Time.zone.now.year}-#{SecureRandom.hex(4).upcase}"
  # end

  def calculate_tax_amount # NEED FIX
    tax_rate = property&.taxes&.sum(&:rate) || 0
    total_price * (tax_rate / 100.0)
  end

  private

  def generate_unique_code
    self.unique_code ||= loop do
      code = SecureRandom.random_number(10**6).to_s.rjust(6, '0')
      break code unless Booking.exists?(unique_code: code)
    end
  end

  def validate_stay_length
    return if property.blank? || start_date.blank? || end_date.blank?

    validate_minimum_stay
    validate_maximum_stay
  end

  def validate_minimum_stay
    if (end_date - start_date).to_i < property.min_days_stay
      errors.add(:base, "Stay must be at least #{property.min_days_stay} days.")
    end
  end

  def validate_maximum_stay
    if (end_date - start_date).to_i > property.max_days_stay
      errors.add(:base, "Stay cannot exceed #{property.max_days_stay} days.")
    end
  end

  def validate_dates
    return unless start_date && end_date

    if end_date <= start_date
      errors.add(:end_date, 'must be after the start date.')
    end
  end

  def ensure_canceled_status
    unless canceled?
      errors.add(:base, 'Booking cannot be deleted unless it is canceled.')
      throw(:abort)
    end
  end
end
