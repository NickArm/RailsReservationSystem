module BookingsHelper
    def status_badge_class(status)
      case status
      when 'unpaid'
        'bg-warning text-dark'
      when 'confirm_payment'
        'bg-info text-white'
      when 'paid'
        'bg-success text-white'
      else
        'bg-secondary text-white'
      end
    end

    def calculate_price_breakdown(property, start_date, end_date)
      return { breakdown: [], total_price: 0 } if property.nil? || start_date.nil? || end_date.nil?

      # Ensure the date range is valid
      if end_date < start_date
        raise ArgumentError, 'End date cannot be earlier than start date'
      end

      days = (start_date..end_date).to_a

      # Fetch all calendar entries for the property within the date range in a single query
      calendar_entries = Calendar.where(property_id: property.id, date: days).index_by(&:date)

      breakdown = days.map do |date|
        {
          date: date,
          price: calendar_entries[date]&.price || property.price || 0 # Use property default price if no calendar entry
        }
      end

      # Calculate base total price
      total_price = breakdown.sum { |entry| entry[:price] }

      # Calculate length of stay
      days_count = days.size

      # Apply discounts based on the length of stay
      if days_count >= 30
        total_price *= (1 - (property.monthly_discount / 100.0))
      elsif days_count >= 7
        total_price *= (1 - (property.weekly_discount / 100.0))
      end

      # Round the total price to two decimal places for consistency
      total_price = total_price.round(2)

      { breakdown: breakdown, total_price: total_price }
    end
end
