class PaymentMethod < ApplicationRecord
    has_many :bookings, dependent: :nullify

    validates :name, presence: true
end
