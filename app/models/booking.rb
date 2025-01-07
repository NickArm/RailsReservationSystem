class Booking < ApplicationRecord
  belongs_to :customer
  belongs_to :property
  belongs_to :payment_method, optional: true
  accepts_nested_attributes_for :customer

  validates :start_date, :end_date, presence: true

  validate :validate_stay_length

  # Method to retrieve the reservation status object
  def reservation_status
    ReservationStatus.find_by(id: status)
  end

  # Method to set the reservation status by name
  def reservation_status=(name)
    status_obj = ReservationStatus.find_by(name: name)
    self.status = status_obj.id if status_obj.present?
  end

  private

  def validate_stay_length
    if property.present?
      days = (end_date - start_date).to_i
      if days < property.min_days_stay
        errors.add(:base, "Stay must be at least #{property.min_days_stay} days")
      elsif days > property.max_days_stay
        errors.add(:base, "Stay cannot exceed #{property.max_days_stay} days")
      end
    end
  end
end
