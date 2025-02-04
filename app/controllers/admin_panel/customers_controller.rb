module AdminPanel
  class CustomersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_customer, only: %i[edit update reservations]
    before_action :set_countries, only: %i[new edit update]

    layout 'admin'

    def index
      @customers = Customer.order(:name)
    end

    def new
      @customer = Customer.new
    end

    def edit; end

    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        redirect_to admin_panel_customers_path, notice: t('admin_panel.customers.created_successfully')
      else
        flash.now[:alert] = t('admin_panel.customers.creation_failed')
        render :new
      end
    end

    def update
      if @customer.update(customer_params)
        redirect_to admin_panel_customers_path, notice: t('admin_panel.customers.updated_successfully')
      else
        flash.now[:alert] = t('admin_panel.customers.update_failed')
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

    def set_countries
      @countries = ISO3166::Country.all.map { |country| [ country.translations[I18n.locale.to_s] || country.name, country.alpha2 ] }.sort_by { |c| c[0] }
    end

    def customer_params
      params.expect(customer: [ :name, :email, :phone, :address, :country, :city, :zip_code ])
    end
  end
end
