class Booking < ApplicationRecord
  # Associations
  belongs_to :customer
  belongs_to :property
  belongs_to :payment_method, optional: false # Set to false if always required
  belongs_to :reservation_status,
             foreign_key: :status,
             class_name: 'ReservationStatus',
             optional: true,
             inverse_of: :bookings

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

  # Custom Getter and Setter for Reservation Status
  def reservation_status
    ReservationStatus.find_by(id: status) || super
  end

  def reservation_status=(name)
    status_obj = ReservationStatus.find_by(name: name)
    self.status = status_obj.id if status_obj.present?
  end

  # Validation Methods
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
    unless reservation_status&.name == 'Canceled'
      errors.add(:base, 'Booking cannot be deleted unless it is canceled.')
      throw(:abort)
    end
  end
end
