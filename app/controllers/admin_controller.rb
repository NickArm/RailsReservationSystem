class AdminController < ApplicationController
  before_action :authenticate_admin!

  layout 'admin'

  def dashboard
    @properties = current_admin.properties

    @upcoming_bookings = Booking.includes(:property)
                                .where('start_date > ?', Time.zone.today)
                                .order(:start_date)
                                .limit(5)
  end
end
