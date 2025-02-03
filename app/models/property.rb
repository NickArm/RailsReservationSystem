class Property < ApplicationRecord
  belongs_to :admin
  has_many :calendars, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :taxes, dependent: :destroy
  has_one_attached :main_image

  validates :min_days_stay, :max_days_stay, numericality: { only_integer: true, greater_than: 0 }
  validates :weekly_discount, :monthly_discount,
  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :min_days_less_than_max_days
  validate :acceptable_image
  accepts_nested_attributes_for :taxes, allow_destroy: true

  private

  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.content_type.start_with?('image/')
      errors.add(:main_image, 'must be an image')
    end

    if main_image.blob.byte_size > 2.megabytes
      errors.add(:main_image, 'size must be less than 2MB')
    end
  end

  def min_days_less_than_max_days
    if min_days_stay.present? && max_days_stay.present? && min_days_stay > max_days_stay
      errors.add(:min_days_stay, 'must be less than or equal to max days stay')
    end
  end
end
