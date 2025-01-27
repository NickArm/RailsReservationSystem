require 'test_helper'

class SearchHelperTest < ActiveSupport::TestCase
  include SearchHelper

  def setup
    @admin = Admin.create!(email: 'admin@example.com', password: 'password')

    @customer1 = Customer.create!(
    name: 'John Doe',
    email: 'john.doe.test@example.com',
    phone: '1234567890',
    address: '123 Main Street',
    country: 'USA',
    city: 'New York',
    zip_code: '10001',
    password: 'password'
  )

  @customer2 = Customer.create!(
    name: 'Jane Smith',
    email: 'jane.smith.test@example.com',
    phone: '9876543210',
    address: '456 Elm Street',
    country: 'USA',
    city: 'Los Angeles',
    zip_code: '90001',
    password: 'password'
  )

    @property1 = Property.create!(
      name: 'Seaside Villa',
      max_guests: 4,
      min_days_stay: 2,
      max_days_stay: 10,
      admin: @admin
    )

    @property2 = Property.create!(
      name: 'Mountain Cabin',
      max_guests: 6,
      min_days_stay: 3,
      max_days_stay: 15,
      admin: @admin
    )

    Calendar.create!(
      property: @property1,
      date: Time.zone.today,
      status: 'open'
    )
    Calendar.create!(
      property: @property1,
      date: Time.zone.today + 4.days,
      status: 'open'
    )
    Calendar.create!(
      property: @property2,
      date: Time.zone.today,
      status: 'open'
    )
    Calendar.create!(
      property: @property2,
      date: Time.zone.today + 6.days,
      status: 'open'
    )

    @payment_method = PaymentMethod.create!(
        name: 'Stripe',
        details: 'Visa ending in 1234'
      )

    Booking.create!(
    property: @property1,
    start_date: Time.zone.today,
    end_date: Time.zone.today + 3.days,
    guest_count: 2,
    customer: @customer1,
    payment_method: @payment_method
  )
  end

  test 'should return error if start_date or end_date is missing' do
    result = search_available_properties({})
    assert_equal 'Start date and end date must be provided', result[:error]
  end

  test 'should return no properties if none match the criteria' do
    result = search_available_properties(
      start_date: (Time.zone.today + 7).to_s,
      end_date: (Time.zone.today + 8).to_s,
      guest_count: 10
    )
    assert_empty result[:properties]
  end

  #   test "should return matching properties for valid search" do
  #     result = search_available_properties(
  #       start_date: Date.today.to_s,
  #       end_date: (Date.today + 6.days).to_s, # Matches @property2's available calendar range
  #       guest_count: 6 # Matches @property2's max_guests
  #     )
  #     assert_includes result[:properties], @property2, "Expected @property2 to be included in the results"
  #     refute_includes result[:properties], @property1, "Expected @property1 to be excluded due to conflicting bookings"
  #   end

  test 'should exclude properties with conflicting bookings' do
    result = search_available_properties(
      start_date: Time.zone.today.to_s,
      end_date: Date.tomorrow.to_s,
      guest_count: 2
    )
    assert_not_includes result[:properties], @property1
  end

  test 'should handle invalid date format gracefully' do
    result = search_available_properties(
      start_date: 'invalid_date',
      end_date: '2025-01-30'
    )
    assert_match /invalid date/, result[:error]
  end
end
