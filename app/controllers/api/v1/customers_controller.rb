class Api::V1::CustomersController < ApplicationController
    def index
        customers = Customer.all
        render json: customers
    end

    def search_by_email
        email = params[:email]
        if email.blank?
          render json: { error: 'Email parameter is required' }, status: :bad_request and return
        end

        customer = Customer.where('LOWER(email) = ?', email.downcase).first

        if customer
          render json: customer
        else
          render json: { error: 'Customer not found' }, status: :not_found
        end
    end
end
