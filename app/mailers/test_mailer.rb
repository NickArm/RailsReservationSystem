# app/mailers/test_mailer.rb
class TestMailer < ApplicationMailer
    def sample_email
      mail(
        to: 'armenisnick@gmail.com',
        from: 'railres@armenisnick.gr',
        subject: 'Test Email from Rails',
        body: 'This is a test email sent from the Rails application.',
        content_type: 'text/plain'
      )
    rescue => e
      Rails.logger.error "Mail delivery failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e # Re-raise to maintain default error behavior
    end
end
