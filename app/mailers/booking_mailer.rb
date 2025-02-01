class BookingMailer < ApplicationMailer
    default from: 'noreply@example.com'

    def admin_notification(booking)
      @booking = booking
      @admin_email = 'admin@example.com'
      mail(to: @admin_email, subject: I18n.t('mailers.booking_mailer.admin_notification.subject'))
    end

    def customer_notification(booking)
      @booking = booking
      mail(to: @booking.customer.email, subject: I18n.t('mailers.booking_mailer.customer_notification.subject'))
    end
end
