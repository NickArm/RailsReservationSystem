module AdminPanel
  class SettingsController < ApplicationController
    layout 'admin'

    def show
      initialize_settings_variables
    end

    def update
      @settings = Setting.first_or_initialize

      if @settings.update(settings_params)
        # Update Enabled Payment Methods
        EnabledPaymentMethod.where(admin_id: current_admin.id).delete_all
        params[:enabled_payment_methods]&.each do |payment_method_id|
          EnabledPaymentMethod.create!(payment_method_id: payment_method_id, admin_id: current_admin.id)
        end

        # Update Payment Method Descriptions
        params[:payment_method_descriptions]&.each do |payment_method_id, description|
          PaymentMethod.find(payment_method_id).update(description: description)
        end

        redirect_to admin_panel_settings_path, notice: 'Settings updated successfully.'
      else
        Rails.logger.error "Settings update failed: #{@settings.errors.full_messages.to_sentence}"
        flash.now[:alert] = 'Failed to update settings. Please check the input fields.'
        initialize_settings_variables # Initialize variables for rendering the :show template
        render :show
      end
    end

    private

    def initialize_settings_variables
      @settings = Setting.first_or_initialize
      @payment_methods = PaymentMethod.all
      @enabled_payment_methods = EnabledPaymentMethod.pluck(:payment_method_id)
    end

    def settings_params
      params.expect(
        setting: [ :company_name, :registration_number, :phone, :company_email, :address, :city,
        :company_postcode, :language, :currency, :notifications_email, :logo,
        :smtp_address, :smtp_port, :smtp_domain, :smtp_user_name, :smtp_password,
        :smtp_authentication, :smtp_enable_starttls, :ssl ]
      )
    end
  end
end
