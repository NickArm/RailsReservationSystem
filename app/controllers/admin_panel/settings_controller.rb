module AdminPanel
  class SettingsController < ApplicationController
    layout 'admin'

    def show
      @settings = Setting.first_or_initialize
      @payment_methods = PaymentMethod.all
      @enabled_payment_methods = EnabledPaymentMethod.pluck(:payment_method_id)
    end

    def update
      @settings = Setting.first_or_initialize

      if @settings.update(settings_params)
        EnabledPaymentMethod.delete_all
        params[:enabled_payment_methods]&.each do |payment_method_id|
          EnabledPaymentMethod.create!(payment_method_id: payment_method_id, admin_id: current_admin.id)
        end

        params[:payment_method_descriptions]&.each do |payment_method_id, description|
          PaymentMethod.find(payment_method_id).update(description: description)
        end

        redirect_to admin_panel_settings_path, notice: 'Settings updated successfully.'
      else
        Rails.logger.error "Settings update failed: #{@settings.errors.full_messages.to_sentence}"
        flash.now[:alert] = 'Failed to update settings. Please check the input fields.'
        render :show
      end
    end

    private

    def settings_params
      params.expect(
        setting: [ :company_name, :registration_number, :phone, :company_email, :address, :city,
        :company_postcode, :language, :currency, :notifications_email, :logo ]
      )
    end
  end
end
