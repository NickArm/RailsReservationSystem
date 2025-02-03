class Customer < ApplicationRecord
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :bookings, dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone, presence: true
    validates :address, presence: true
    validates :country, presence: true
    validates :city, presence: true
    validates :zip_code, presence: true

    # Skip password validation if a password is not required
    validates :password, presence: true, if: :password_required?

    private

    def password_required?
      new_record? || password.present?
    end
end
