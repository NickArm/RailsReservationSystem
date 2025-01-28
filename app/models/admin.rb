class Admin < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

           has_many :properties, dependent: :restrict_with_exception
           has_many :enabled_payment_methods
            has_many :payment_methods, through: :enabled_payment_methods
end
