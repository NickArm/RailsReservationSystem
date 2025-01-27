module Api::V1::SearchHelper
    def search_available_properties(params)
        start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
        end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil
        guest_count = params[:guest_count].present? ? params[:guest_count].to_i : nil

        # Ensure both dates are present
        return { error: 'Start date and end date must be provided' } unless start_date && end_date

        # Calculate total stay duration
        stay_duration = (end_date - start_date + 1).to_i

        # Scope to all properties
        scope = Property.all

        # Filter properties based on guest count
        scope = scope.where(max_guests: guest_count..) if guest_count

        # Find available properties that satisfy min and max days of stay
        properties = scope.joins(:calendars)
                          .where(calendars: { date: start_date..end_date, status: 'open' })
                          .where(min_days_stay: ..stay_duration)
                          .where(max_days_stay: stay_duration..)
                          .group('properties.id')
                          .having('COUNT(calendars.id) = ?', stay_duration)

        # Remove properties with conflicting bookings
        properties = properties.reject do |property|
          property.bookings.exists?([ 'start_date <= ? AND end_date >= ?', end_date, start_date ])
        end

        # Serialize properties for API response
        serialized_properties = properties.map do |property|
          {
            id: property.id,
            name: property.name,
            address: property.address,
            max_guests: property.max_guests,
            min_days_stay: property.min_days_stay,
            max_days_stay: property.max_days_stay,
            weekly_discount: property.weekly_discount,
            monthly_discount: property.monthly_discount
          }
        end

        { properties: serialized_properties }
      rescue ArgumentError => e
        { error: e.message }
      end
end
