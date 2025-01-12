class BookingsController < ApplicationController
  before_action :set_property
  before_action :set_property, except: [ :lookup_customer ]
  include BookingsHelper

  def index
    @bookings = Booking.includes(:customer, :property, :payment_method, :reservation_status)
                       .order(created_at: :desc)
  end

  def show
    @booking = @property.bookings.find(params[:id])
  end

  def new
    @booking = @property.bookings.new(
      start_date: params[:start_date],
      end_date: params[:end_date],
      guest_count: params[:guest_count]
    )

  # Lookup customer if email is provided
  if params[:email].present?
    customer = Customer.find_by(email: params[:email])
    if customer
      @booking.assign_attributes(
        customer_name: customer.name,
        customer_email: customer.email,
        customer_phone: customer.phone,
        customer_address: customer.address,
        customer_country: customer.country,
        customer_city: customer.city,
        customer_zip_code: customer.zip_code
      )
      flash.now[:notice] = t('bookings.customer_found')
    else
      flash.now[:alert] = t('bookings.customer_not_found')
    end
  end

    if dates_present?(params[:start_date], params[:end_date])
      begin
        parsed_dates = parse_dates(params[:start_date], params[:end_date])
        validate_date_range(parsed_dates[:start], parsed_dates[:end])

        price_data = calculate_price_breakdown(@property, parsed_dates[:start], parsed_dates[:end])
        set_price_details(price_data, parsed_dates[:start], parsed_dates[:end])
      rescue StandardError => e
        Rails.logger.error "Error in processing booking: #{e.message}"
        set_empty_price_details
        flash.now[:alert] = t('.invalid_dates')
      end
    else
      set_default_dates
      set_empty_price_details
    end
  end

  def create
    # Separate customer-related attributes
    customer_attributes = booking_params.slice(
      :name, :email, :phone, :address, :country, :zip_code, :city
    )

    # Remove customer attributes from booking parameters
    booking_attributes = booking_params.except(
      :name, :email, :phone, :address, :country, :zip_code, :city
    )

    # Initialize booking and associate with property
    @booking = @property.bookings.new(booking_attributes)

    # Find or create customer
    customer = find_or_initialize_customer(customer_attributes)

    if customer.save
      @booking.customer = customer # Associate customer with booking
      assign_total_price

      if @booking.save
        redirect_to property_booking_path(@property, @booking), notice: t('.success')
      else
        flash.now[:alert] = @booking.errors.full_messages.to_sentence
        render :new
      end
    else
      flash.now[:alert] = customer.errors.full_messages.to_sentence
      render :new
    end
  end

  def lookup_customer
    customer = Customer.find_by(email: params[:email])
    if customer
      render json: { customer: customer.slice(:name, :email, :phone, :address, :country, :city, :zip_code) },
status: :ok
    else
      render json: { error: 'Customer not found' }, status: :not_found
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def parse_dates(start_date, end_date)
    {
      start: safe_parse_date(start_date),
      end: safe_parse_date(end_date)
    }
  end

  def safe_parse_date(date_string)
    Date.parse(date_string.to_s) rescue nil
  end

  def validate_date_range(start_date, end_date)
    if start_date.nil? || end_date.nil? || end_date < start_date
      raise ArgumentError, 'Invalid date range: end_date cannot be before start_date'
    end
  end

  def set_price_details(price_data, start_date, end_date)
    @price_breakdown = price_data[:breakdown]
    @total_before_discount = @price_breakdown.sum { |entry| entry[:price] }
    @total_price = price_data[:total_price]
    @discount = @total_before_discount - @total_price
    @discount_type = calculate_discount_type(start_date, end_date)
  end

  def set_empty_price_details
    @price_breakdown = []
    @total_price = 0
    @discount = 0
    @discount_type = t('bookings.no_discount')
  end

  def set_default_dates
    @booking.start_date ||= Time.zone.today
    @booking.end_date ||= Time.zone.today + 1
  end

  def calculate_discount_type(start_date, end_date)
    days = (end_date - start_date).to_i

    case days
    when 30..Float::INFINITY
      t('bookings.discount_type.monthly')
    when 7...30
      t('bookings.discount_type.weekly')
    else
      t('bookings.discount_type.none')
    end
  end

  def assign_total_price
    price_data = calculate_price_breakdown(@property, @booking.start_date, @booking.end_date)
    @booking.total_price = price_data[:total_price]
  end

  def find_or_initialize_customer(customer_params)
    Customer.find_by(email: customer_params[:email]) || Customer.new(customer_params)
  end

  def booking_params
    params.require(:booking).permit(
      :start_date, :end_date, :guest_count, :payment_method_id, :status,
      :name, :email, :phone, :address, :country, :zip_code, :city
    )
  end

  def dates_present?(start_date, end_date)
    start_date.present? && end_date.present?
  end
end
