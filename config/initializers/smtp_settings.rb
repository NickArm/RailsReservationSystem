# Rails.application.config.to_prepare do
#     begin
#       Rails.logger.info "Initializing SMTP settings..."
#       settings = Setting.first

#       if settings&.smtp_address.present?
#         smtp_settings = {
#             address: settings.smtp_address,
#             port: settings.smtp_port,
#             domain: settings.smtp_domain,
#             user_name: settings.smtp_user_name,
#             password: settings.smtp_password,
#             authentication: settings.smtp_authentication.presence || "plain",
#             enable_starttls_auto: settings.smtp_enable_starttls,
#             ssl: settings.ssl || false
#         }
#         Rails.application.config.action_mailer.smtp_settings = smtp_settings
#         Rails.logger.info "Custom SMTP settings applied: #{smtp_settings.inspect}"
#       else
#         Rails.logger.warn "No SMTP settings found in the database. Using default."
#       end
#     rescue => e
#       Rails.logger.error "Error initializing SMTP settings: #{e.message}"
#       Rails.logger.error e.backtrace.join("\n")
#     end
#   end
