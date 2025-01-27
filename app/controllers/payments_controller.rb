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
            name: "Booking ##{@booking.id} for #{@booking.property.name}"
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
    paid_status = ReservationStatus.find_by(name: 'Paid')
    if paid_status && @booking.update(reservation_status: paid_status)
      BookingMailer.admin_notification(@booking).deliver_now
      BookingMailer.customer_notification(@booking).deliver_now
      redirect_to property_booking_path(@booking.property, @booking),
notice: 'Payment successful! Your booking is confirmed.'
    else
      Rails.logger.error "Failed to update booking: #{@booking.errors.full_messages}"
      redirect_to property_booking_path(@booking.property, @booking),
alert: 'Payment was successful, but there was an issue updating the booking.'
    end
  end

  def cancel
    @booking.update(status: 'unpaid') if @booking

    redirect_to property_booking_path(@booking.property, @booking), alert: 'Payment was canceled. Please try again.'
  end

  private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Booking not found.'
  end
end
