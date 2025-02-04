class CustomersController < ApplicationController
    before_action :store_booking_referrer, only: [ :profile ]
    before_action :set_countries

    def profile
      @customer = current_customer
    end

    def update
      @customer = current_customer
      if @customer.update(customer_params)
        redirect_to(session[:booking_referrer] || root_path, notice: t('.success'))
      else
        flash.now[:alert] = @customer.errors.full_messages.to_sentence
        render :profile
      end
    end

    private

    def customer_params
      params.expect(customer: [ :name, :email, :phone, :address, :country, :city, :zip_code, :password,
:password_confirmation ])
    end

    def store_booking_referrer
      session[:booking_referrer] = request.referer if request.referer&.include?('/bookings')
    end
end
