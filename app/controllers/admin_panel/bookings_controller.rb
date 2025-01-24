module AdminPanel
  class BookingsController < ApplicationController
    include BookingsHelper
    before_action :authenticate_admin!
    before_action :set_booking, only: %i[show edit update destroy]
    before_action :load_payment_methods, only: %i[edit update]
    layout 'admin'

    def index
      @bookings = Booking.includes(:customer, :property, :payment_method, :reservation_status)
                         .order(created_at: :desc)
    end

    def show
      calculate_price_details
    end

    def new
      @property = Property.find(params[:property_id])
      @booking = @property.bookings.new(new_booking_params)
      load_customers_and_price_details
    end

    def edit
      # Form to edit a booking
    end

    def create
      @booking = Booking.new(booking_params)

      if validate_booking && @booking.save

        # Send email notifications
        BookingMailer.admin_notification(@booking).deliver_now
        Rails.logger.debug('Admin notification email sent')
        # BookingMailer.customer_notification(@booking).deliver_now
        redirect_to admin_panel_booking_path(@booking), notice: t('admin_panel.bookings.created_successfully')
      else
        load_customers_and_price_details
        flash.now[:alert] = @booking.errors.full_messages.to_sentence
        render :new
      end
    end

    def update
      if @booking.update(booking_params)
        redirect_to admin_panel_booking_path(@booking), notice: t('admin_panel.bookings.updated_successfully')
      else
        render :edit
      end
    end

    def destroy
      if deletable_booking?
        if @booking.destroy
          redirect_to admin_panel_bookings_path, notice: t('admin_panel.bookings.deleted_successfully')
        else
          redirect_to admin_panel_bookings_path, alert: t('admin_panel.bookings.delete_failed')
        end
      else
        redirect_to admin_panel_bookings_path, alert: t('admin_panel.bookings.delete_restricted')
      end
    end

    def calendar_data
      bookings = Booking.includes(:property, :customer).all

      events = bookings.map do |booking|
        {
          title: "#{booking.customer.name} - #{booking.property.name}",
          start: booking.start_date.to_s,
          end: (booking.end_date + 1.day).to_s,
          allDay: true
        }
      end

      render json: events
    end

    private

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def load_payment_methods
      @payment_methods = PaymentMethod.all
    end

    def booking_params
      params.require(:booking).permit(
        :property_id, :start_date, :end_date, :guest_count, :payment_method_id,
        :customer_id, :status, :total_price
      )
    end

    def new_booking_params
      params.permit(:start_date, :end_date, :guest_count)
    end

    def calculate_price_details
      price_data = calculate_price_breakdown(@booking.property, @booking.start_date, @booking.end_date,
@booking.guest_count)

      # Assign values with nil checks
      @price_breakdown = price_data[:breakdown] || []
      @base_total_price = price_data[:base_total_price] || 0 # Default to 0 if nil
      @total_before_discount = price_data[:total_before_discount] || 0
      @total_taxes = price_data[:total_taxes] || 0
      @tax_details = price_data[:tax_details] || []
      @total_price = price_data[:total_price] || 0

      # Calculate discount safely
      @discount = @base_total_price - @total_before_discount
      @discount_type = determine_discount_type
    end

    def load_customers_and_price_details
      @customers = Customer.all
      calculate_price_details
    end

    def determine_discount_type
      days = (@booking.end_date - @booking.start_date).to_i
      return 'Monthly Discount' if days >= 30
      return 'Weekly Discount' if days >= 7
      'No Discount'
    end

    def validate_booking
      if @booking.customer_id.blank?
        flash.now[:alert] = t('admin_panel.bookings.select_customer')
        render :new and return false
      end

      if @booking.payment_method_id.blank?
        flash.now[:alert] = t('admin_panel.bookings.select_payment_method')
        render :new and return false
      end

      true
    end

    def deletable_booking?
      @booking.status == 'canceled' || @booking.reservation_status&.name == 'Canceled'
    end
  end
end
