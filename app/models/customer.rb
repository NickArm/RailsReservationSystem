class Customer < ApplicationRecord
    has_many :bookings, dependent: :destroy

    validates :name, :email, :phone, :address, :country, presence: true
    validates :email, uniqueness: true
end
