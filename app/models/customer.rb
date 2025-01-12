class Customer < ApplicationRecord
    has_many :bookings, dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, presence: true
    validates :address, presence: true
    validates :country, presence: true
    validates :city, presence: true
    validates :zip_code, presence: true
end
