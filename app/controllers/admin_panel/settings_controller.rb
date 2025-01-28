module AdminPanel
  class SettingsController < ApplicationController
    layout 'admin'

    def show
      @payment_methods = PaymentMethod.all
      @enabled_payment_methods = EnabledPaymentMethod.pluck(:payment_method_id)
    end

    def update
      # Clear existing enabled payment methods
      EnabledPaymentMethod.delete_all

      # Save the enabled payment methods
      if params[:enabled_payment_methods].present?
        params[:enabled_payment_methods].each do |payment_method_id|
          EnabledPaymentMethod.create!(
            payment_method_id: payment_method_id,
            admin_id: current_admin.id # Ensure admin_id is set
          )
        end
      end

      # Update payment method descriptions
      if params[:payment_method_descriptions].present?
        params[:payment_method_descriptions].each do |payment_method_id, description|
          PaymentMethod.find(payment_method_id).update(description: description)
        end
      end

      redirect_to admin_panel_settings_path, notice: 'Settings updated successfully.'
    end
  end
end
