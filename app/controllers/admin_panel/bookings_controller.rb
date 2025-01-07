module AdminPanel
  class BookingsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_booking, only: [ :show, :edit, :update, :destroy ]
    before_action :load_payment_methods, only: [ :edit, :update ]
    layout 'admin'

    def index
      @bookings = Booking.includes(:customer, :property, :payment_method).order(created_at: :desc)
    end

    def show
      @booking = Booking.includes(:customer, :property, :payment_method).find(params[:id])
      start_date = @booking.start_date
      end_date = @booking.end_date

      # Calculate price breakdown and totals
      price_data = calculate_price_breakdown(@booking.property, start_date, end_date)
      @price_breakdown = price_data[:breakdown]
      @total_before_discount = @price_breakdown.sum { |entry| entry[:price] }
      @total_price = price_data[:total_price]

      # Calculate the discount
      @discount = @total_before_discount - @total_price
      @discount_type = if (end_date - start_date).to_i >= 30
                         'Monthly Discount'
      elsif (end_date - start_date).to_i >= 7
                         'Weekly Discount'
      else
                         'No Discount'
      end
    end

    def edit
      # Form to edit a booking
    end

    def update
      if @booking.update(booking_params)
        redirect_to admin_panel_booking_path(@booking), notice: 'Booking successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @booking.destroy
      redirect_to admin_panel_bookings_path, notice: 'Booking successfully deleted.'
    end

    private

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def load_payment_methods
      @payment_methods = PaymentMethod.all
    end

    def booking_params
      params.require(:booking).permit(:name, :email, :phone, :start_date, :end_date, :guest_count, :status,
:property_id, :payment_method_id)
    end
  end
end
