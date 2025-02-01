class AdminController < ApplicationController
  before_action :authenticate_admin!
  before_action :load_settings
  layout 'admin'

  def dashboard
    @properties = current_admin.properties

    @upcoming_bookings = Booking.includes(:property)
                                .where('start_date > ?', Time.zone.today)
                                .order(:start_date)
                                .limit(5)

    @total_bookings = Booking.count
    @total_customers = Customer.count
    @upcoming_bookings_dashboard = Booking.where(start_date: Time.zone.today..).count
    @total_income = Booking.sum(:total_price)
  end

  private

  def load_settings
    @settings = Setting.first_or_initialize
  end
end
