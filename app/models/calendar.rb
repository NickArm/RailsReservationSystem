class Calendar < ApplicationRecord
  belongs_to :property

  validates :date, presence: true, uniqueness: { scope: :property_id }
  validates :status, inclusion: { in: [ 'open', 'closed' ] }
  validates :price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
end
