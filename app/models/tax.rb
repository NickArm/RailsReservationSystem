class Tax < ApplicationRecord
  belongs_to :property

  enum :rate_type, { flat: 0, percentage: 1 }
  enum :application_case, { per_guest: 0, per_day: 1, per_booking: 2 }

  validates :rate, presence: true, numericality: { greater_than: 0 }
  validates :rate_type, :application_case, presence: true
end
