class BookingsController < ApplicationController
  before_action :set_property
  include BookingsHelper

  def index
    @bookings = Booking.includes(:customer, :property, :payment_method).order(created_at: :desc)
  end

  def show
    @booking = @property.bookings.find(params[:id])
  end

  def new
    @property = Property.find(params[:property_id])
    @booking = @property.bookings.new(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )

    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])

        # Calculate price breakdown and totals
        price_data = calculate_price_breakdown(@property, start_date, end_date)
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
      rescue ArgumentError
        flash.now[:alert] = 'Invalid dates selected. Please choose valid start and end dates.'
        @price_breakdown = []
        @total_price = 0
        @discount = 0
        @discount_type = 'No Discount'
      end
    else
      @price_breakdown = []
      @total_price = 0
      @discount = 0
      @discount_type = 'No Discount'
    end
  end

  def create
    @booking = @property.bookings.new(booking_params.except(:customer_name, :customer_email, :customer_phone,
                                                            :customer_address, :customer_country))

    # Find or create the customer
    customer = Customer.find_by(email: booking_params[:customer_email]) || Customer.new(
      name: booking_params[:customer_name],
      email: booking_params[:customer_email],
      phone: booking_params[:customer_phone],
      address: booking_params[:customer_address],
      country: booking_params[:customer_country]
    )

    unless customer.save
      flash.now[:alert] = 'There was an error creating the customer. Please try again.'
      render :new and return
    end

    @booking.customer = customer

    # Calculate price breakdown and apply discounts
    if @booking.start_date && @booking.end_date
      start_date = @booking.start_date
      end_date = @booking.end_date

      price_data = calculate_price_breakdown(@property, start_date, end_date)
      @booking.total_price = price_data[:total_price]

      # For debugging, you can log or inspect the breakdown if needed
      # logger.debug price_data[:breakdown]

    else
      flash.now[:alert] = 'Start date and end date are required to calculate the total price.'
      render :new and return
    end

    # Save booking
    if @booking.save
      redirect_to property_booking_path(@property, @booking), notice: 'Booking was successfully created.'
    else
      flash.now[:alert] = 'There was an error creating the booking. Please try again.'
      render :new
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def booking_params
    params.require(:booking).permit(
      :start_date, :end_date, :guest_count, :payment_method_id,
      :customer_name, :customer_email, :customer_phone, :customer_address, :customer_country
    )
  end
end
