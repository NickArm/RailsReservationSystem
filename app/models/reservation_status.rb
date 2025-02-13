# app/models/reservation_status.rb
class ReservationStatus < ApplicationRecord
    has_many :bookings, foreign_key: :status, dependent: :nullify, inverse_of: :reservation_status
end
