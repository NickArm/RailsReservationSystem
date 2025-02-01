class Admin < ApplicationRecord
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :properties, dependent: :restrict_with_exception
    has_many :enabled_payment_methods, dependent: :destroy
    has_many :payment_methods, through: :enabled_payment_methods
end
