class Api::V1::BookingsController < ApplicationController
    def index
        bookings = Booking.includes(:property, :customer).all
        render json: bookings, include: [ :property, :customer ]
      end
end
