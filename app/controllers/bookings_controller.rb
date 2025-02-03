class BookingsController < ApplicationController
  before_action :set_property
  before_action :set_property, except: [ :lookup_customer ]
  before_action :set_settings
  include BookingsHelper

  def index
    @bookings = Booking.includes(:customer, :property, :payment_method)
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
    @enabled_payment_methods = EnabledPaymentMethod.includes(:payment_method).map(&:payment_method) || []

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
    customer_attributes = booking_params.slice(:name, :email, :phone, :address, :country, :zip_code, :city)
    booking_attributes = booking_params.except(:name, :email, :phone, :address, :country, :zip_code, :city)

    @enabled_payment_methods = EnabledPaymentMethod.includes(:payment_method).map(&:payment_method) || []

    # Check if the property is still available
    if booking_conflict?(booking_attributes[:start_date], booking_attributes[:end_date])
      @booking = @property.bookings.new(booking_attributes)
      flash.now[:alert] = 'Sorry, the property is no longer available for the selected dates.'
      render :new and return
    end

    # Find an existing customer or initialize a new one
    customer = Customer.find_by(email: customer_attributes[:email]) || Customer.new(customer_attributes)

    # Assign a random password for new customers - On email should add restore password functionality
    if customer.new_record?
      customer.password = SecureRandom.hex(8)
      Rails.logger.debug { "Generated Password for New Customer: #{customer.password}" }
    end

    if customer.new_record?
      unless customer.save
        @booking = @property.bookings.new(booking_attributes) # Reinitialize @booking
        flash.now[:alert] = customer.errors.full_messages.to_sentence
        render :new and return
      end
    end

    @booking = @property.bookings.new(booking_attributes)
    @booking.customer = customer
    @booking.status = 'unpaid'

    assign_total_price

    if @booking.save
      if @booking.payment_method&.name == 'Stripe'
        redirect_to create_payment_intent_path(booking_id: @booking.id)
      else
        BookingMailer.admin_notification(@booking).deliver_now
        BookingMailer.customer_notification(@booking).deliver_now
        redirect_to property_booking_path(@property, @booking), notice: t('.success')
      end
    else
      Rails.logger.debug { "Booking Save Failed: #{@booking.errors.full_messages}" }
      flash.now[:alert] = @booking.errors.full_messages.to_sentence
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

  def set_settings
    @settings = Setting.first_or_initialize
  end

  def set_property
    @property = Property.find(params[:property_id])
  end

  def booking_conflict?(start_date, end_date)
    overlapping_bookings = @property.bookings
                                    .where('start_date < ? AND end_date > ?', end_date, start_date)
    overlapping_bookings.exists?
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
    @base_total_price = price_data[:base_total_price]
    @total_taxes = price_data[:total_taxes]
    @tax_details = price_data[:tax_details]
    @total_price = price_data[:total_price]
    @discount = @base_total_price - price_data[:total_price] + price_data[:total_taxes]
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

  def booking_params
    params.expect(
      booking: [ :start_date, :end_date, :guest_count, :payment_method_id,
      :status, :name, :email, :phone, :address, :country, :zip_code, :city ]
    )
  end

  def dates_present?(start_date, end_date)
    start_date.present? && end_date.present?
  end
end
