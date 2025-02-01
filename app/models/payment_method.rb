class PaymentMethod < ApplicationRecord
    has_many :bookings, dependent: :nullify
    has_many :enabled_payment_methods, dependent: :destroy
    has_many :admins, through: :enabled_payment_methods

    validates :name, presence: true
end
