class BookingMailer < ApplicationMailer
    default from: 'noreply@example.com'

    def admin_notification(booking)
      @booking = booking
      @admin_email = 'admin@example.com'
      mail(to: @admin_email, subject: 'New Booking Received')
    end

    def customer_notification(booking)
      @booking = booking
      mail(to: @booking.customer.email, subject: 'Your Booking Confirmation')
    end
end
