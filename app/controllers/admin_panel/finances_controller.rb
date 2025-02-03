module AdminPanel
  class FinancesController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!

    def index
      @total_revenue = Invoice.where(payment_status: 1).sum(:total_amount)
      @total_taxes = Invoice.sum(:tax_amount)
      @pending_payments = Invoice.where(payment_status: 0).sum(:total_amount)

      @payment_methods = PaymentMethod
                          .joins(bookings: :invoices)
                          .where(invoices: { payment_status: 1 })
                          .group('payment_methods.name')
                          .select('payment_methods.name, COUNT(bookings.id) as transaction_count, SUM(invoices.total_amount) as total_revenue')

      @tax_summary = Tax.joins(property: { bookings: :invoices })
                        .group('taxes.name')
                        .sum('invoices.tax_amount')
    end
  end
end
