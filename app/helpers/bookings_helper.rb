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

    def calculate_price_breakdown(property, start_date, end_date, guest_count = 1)
      return { breakdown: [], total_price: 0, tax_details: [],
total_taxes: 0 } if property.nil? || start_date.nil? || end_date.nil?

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

      # Base total price
      base_total_price = breakdown.sum { |entry| entry[:price] }

      # Calculate length of stay
      days_count = days.size

      # Apply discounts based on the length of stay
      if days_count >= 30
        base_total_price *= (1 - (property.monthly_discount / 100.0))
      elsif days_count >= 7
        base_total_price *= (1 - (property.weekly_discount / 100.0))
      end

      # Round the base total price to two decimal places
      base_total_price = base_total_price.round(2)

      # Calculate taxes
      tax_details = calculate_taxes(property, base_total_price, days_count, guest_count)
      total_taxes = tax_details.sum { |tax| tax[:amount] }

      # Final total price
      total_price = (base_total_price + total_taxes).round(2)

      {
        breakdown: breakdown,
        total_price: total_price,
        tax_details: tax_details,
        total_taxes: total_taxes,
        base_total_price: base_total_price
      }
    end

    private

  def calculate_taxes(property, base_price, days_count, guest_count)
    return [] if property.taxes.empty?

    property.taxes.map do |tax|
      tax_amount = case tax.application_case
      when 'per_day'
                     tax.rate_type == 'percentage' ? (base_price * (tax.rate / 100.0) / days_count) : (tax.rate * days_count)
      when 'per_guest'
                     tax.rate_type == 'percentage' ? (base_price * (tax.rate / 100.0) / guest_count) : (tax.rate * guest_count)
      when 'per_booking'
                     tax.rate_type == 'percentage' ? (base_price * (tax.rate / 100.0)) : tax.rate
      else
                     0
      end

      {
        name: tax.name,
        rate_type: tax.rate_type,
        application_case: tax.application_case,
        rate: tax.rate,
        amount: tax_amount.round(2)
      }
    end
  end
end
