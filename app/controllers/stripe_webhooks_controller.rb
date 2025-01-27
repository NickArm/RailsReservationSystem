class StripeWebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        # Verify the webhook signature using Stripe's library
        event = Stripe::Webhook.construct_event(
          payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET']
        )
      rescue JSON::ParserError => e
        render json: { error: 'Invalid payload' }, status: :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: 'Invalid signature' }, status: :bad_request
        return
      end

      case event['type']
      when 'payment_intent.succeeded'
        handle_payment_intent(event['data']['object'], 'paid')
      when 'payment_intent.payment_failed'
        handle_payment_intent(event['data']['object'], 'payment_failed')
      end


      render json: { message: 'Event received' }, status: :ok
    end

    private

    def handle_payment_intent(payment_intent, status)
        booking_id = payment_intent['metadata']['booking_id']
        booking = Booking.find_by(id: booking_id)

        if booking
          booking.update(status: status)
          Rails.logger.info "Booking #{booking.id} marked as #{status}"
        else
          Rails.logger.error "Booking with ID #{booking_id} not found for #{status} payment"
        end
      end

  end
