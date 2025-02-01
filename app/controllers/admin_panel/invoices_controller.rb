module AdminPanel
    class InvoicesController < ApplicationController
      layout 'admin'
      before_action :set_booking, only: [ :new, :create ]
      before_action :set_settings, only: [ :show, :new, :create ]
  def index
    @invoices = Invoice.includes(:booking, :customer)
                       .order(issued_date: :desc)

    @invoices = @invoices.where('invoice_number ILIKE ?', "%#{params[:invoice_number]}%") if params[:invoice_number].present?
    @invoices = @invoices.where('customers.name ILIKE ?', "%#{params[:customer_name]}%") if params[:customer_name].present?
    @invoices = @invoices.where(status: params[:status]) if params[:status].present?
    if params[:date_range].present?
      start_date, end_date = params[:date_range].split(' - ').map { |d| Date.parse(d) rescue nil }
      @invoices = @invoices.where(issued_date: start_date..end_date) if start_date && end_date
    end
  end

  def show
    @invoice = Invoice.includes(:booking, :customer).find(params[:id])
  end

  def new
    @booking = Booking.find(params[:booking_id])
    @invoice = @booking.invoices.build(
      invoice_number: generate_invoice_number,
      total_amount: @booking.total_price,
      tax_amount: calculate_tax(@booking),
      vat_number: '',
      payment_status: :pending,
      issued_date: Time.zone.now,
      due_date: 7.days.from_now
    )
    @invoice.customer = @booking.customer
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @invoice = @booking.invoices.build(invoice_params)
    @invoice.customer = @booking.customer
    if @invoice.save
      redirect_to admin_panel_booking_path(@booking), notice: 'Invoice created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_settings
    @settings = Setting.first
  end

  def invoice_params
    params.expect(invoice: [ :invoice_number, :total_amount, :tax_amount, :vat_number, :payment_status, :issued_date, :due_date, :notes ])
  end

  def generate_invoice_number
    "#{Time.zone.now.year}-#{SecureRandom.hex(4).upcase}"
  end

  def calculate_tax(booking)
    tax_rate = booking.property.taxes.sum(&:rate) || 0
    booking.total_price * (tax_rate / 100.0)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def invoice_params
    params.expect(invoice: [ :invoice_number, :total_amount, :tax_amount, :payment_status, :vat_number, :issued_date, :due_date, :notes ])
  end
    end
end
