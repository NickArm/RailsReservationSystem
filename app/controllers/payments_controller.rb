class PaymentsController < ApplicationController
  before_action :set_booking

  def create_payment_intent
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    total_price = @booking.total_price

    Stripe::PaymentIntent.create(
      amount: (total_price * 100).to_i,
      currency: 'usd',
      metadata: { booking_id: @booking.id },
      payment_method_types: [ 'card' ]
    )

    session = Stripe::Checkout::Session.create(
      payment_method_types: [ 'card' ],
      line_items: [ {
        price_data: {
          currency: 'usd',
          product_data: {
            name: t('payments.create.product_name', booking_id: @booking.id, property_name: @booking.property.name)
          },
          unit_amount: (total_price * 100).to_i
        },
        quantity: 1
      } ],
      mode: 'payment',
      success_url: payment_success_url(booking_id: @booking.id),
      cancel_url: payment_cancel_url(booking_id: @booking.id),
    )

    redirect_to session.url, allow_other_host: true
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def success
    if @booking.update!(status: :paid)
      invoice = @booking.invoices.last
      invoice.update!(payment_status: :paid) if invoice

      BookingMailer.admin_notification(@booking).deliver_now
      BookingMailer.customer_notification(@booking).deliver_now

      redirect_to property_booking_path(@booking.property, @booking), notice: t('.booking_confirmed')
    else
      redirect_to property_booking_path(@booking.property, @booking), alert: t('.booking_update_failed')
    end
  end

  def cancel
    if @booking.update(status: :unpaid)
      redirect_to property_booking_path(@booking.property, @booking), notice: t('.payment_canceled')
    else
      redirect_to property_booking_path(@booking.property, @booking), alert: t('.booking_update_failed')
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: t('payments.set_booking.not_found')
  end
end
