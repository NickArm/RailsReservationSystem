class Property < ApplicationRecord
  belongs_to :admin
  has_many :calendars, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :min_days_stay, :max_days_stay, numericality: { only_integer: true, greater_than: 0 }
  validates :weekly_discount, :monthly_discount,
numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :min_days_less_than_max_days

  private

  def min_days_less_than_max_days
    if min_days_stay.present? && max_days_stay.present? && min_days_stay > max_days_stay
      errors.add(:min_days_stay, 'must be less than or equal to max days stay')
    end
  end
end
