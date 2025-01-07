module AdminPanel
    class CustomersController < ApplicationController
      before_action :authenticate_admin!
      before_action :set_customer, only: [ :edit, :update, :reservations ]
      layout 'admin'

      def index
        @customers = Customer.all
      end

      def new
        @customer = Customer.new
      end

      def edit
        # @customer is set by before_action
      end
      def create
        @customer = Customer.new(customer_params)
        if @customer.save
          redirect_to admin_panel_customers_path, notice: 'Customer successfully created.'
        else
          flash.now[:alert] = 'There was an error creating the customer. Please try again.'
          render :new
        end
      end

      def update
        if @customer.update(customer_params)
          redirect_to admin_panel_customers_path, notice: 'Customer successfully updated.'
        else
          flash.now[:alert] = 'There was an error updating the customer. Please try again.'
          render :edit
        end
      end

      def reservations
        @reservations = @customer.bookings.includes(:property, :payment_method)
      end

      private

      def set_customer
        @customer = Customer.find(params[:id])
      end

      def customer_params
        params.require(:customer).permit(:name, :email, :phone, :address, :country, :city, :zip_code)
      end

    end
end
