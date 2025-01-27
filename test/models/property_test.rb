require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
    def setup
        @admin = Admin.create!(email: "admin#{SecureRandom.hex(4)}@example.com", password: 'password')
        @property = Property.new(
          name: 'Beach House',
          address: '123 Ocean Drive',
          min_days_stay: 3,
          max_days_stay: 10,
          weekly_discount: 15.0,
          monthly_discount: 25.0,
          admin: @admin
        )
    end

  # Association Tests
  test 'should belong to an admin' do
    assert @property.admin.present?
  end

  test 'should have many calendars, bookings, and taxes' do
    assert_respond_to @property, :calendars
    assert_respond_to @property, :bookings
    assert_respond_to @property, :taxes
  end

  # Validation Tests
  test 'should be valid with valid attributes' do
    assert @property.valid?
  end

  test 'should not be valid without an admin' do
    @property.admin = nil
    assert_not @property.valid?
    assert_includes @property.errors[:admin], 'must exist'
  end

  test 'should not allow min_days_stay greater than max_days_stay' do
    @property.min_days_stay = 15
    @property.max_days_stay = 10
    assert_not @property.valid?
    assert_includes @property.errors[:min_days_stay], 'must be less than or equal to max days stay'
  end

  test 'should not allow discounts outside valid range' do
    @property.weekly_discount = 120
    @property.monthly_discount = -10
    assert_not @property.valid?
    assert_includes @property.errors[:weekly_discount], 'must be less than or equal to 100'
    assert_includes @property.errors[:monthly_discount], 'must be greater than or equal to 0'
  end
end
