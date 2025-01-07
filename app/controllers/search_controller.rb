class SearchController < ApplicationController
  def index
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      # Calculate the total stay duration
      stay_duration = (end_date - start_date + 1).to_i

      # Scope to all properties
      scope = Property.all

      # Filter properties based on guest count if provided
      if params[:guest_count].present?
        guest_count = params[:guest_count].to_i
        scope = scope.where(max_guests: guest_count..)
      end

      # Find available properties that satisfy min and max days of stay
      @properties = scope.joins(:calendars)
                         .where(calendars: { date: start_date..end_date, status: 'open' })
                         .where(min_days_stay: ..stay_duration)
                         .where(max_days_stay: stay_duration..)
                         .group('properties.id')
                         .having('COUNT(calendars.id) = ?', stay_duration)

      # Remove properties that have conflicting bookings
      @properties = @properties.reject do |property|
        property.bookings.exists?([ 'start_date <= ? AND end_date >= ?', end_date, start_date ])
      end

      # Render or redirect based on the results
      if @properties.size > 1
        flash[:notice] = 'Multiple houses are available. Please select one.'
        render :available_properties and return
      elsif @properties.size == 1
        redirect_to new_property_booking_path(@properties.first, start_date: params[:start_date],
                                              end_date: params[:end_date])
      else
        flash[:alert] =
          "No houses are available for the selected dates or the stay duration doesn't meet the property's requirements."
        render :index
      end
    else
      # Render all properties if no dates are selected
      @properties = Property.all
    end
  end
end
