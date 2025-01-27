require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.new(
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '1234567890',
      address: '123 Main Street',
      city: 'New York',
      country: 'USA',
      zip_code: '10001',
      password: 'password'
    )
  end

  # Validations

  test 'should require a name' do
    @customer.name = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:name], "can't be blank"
  end

  test 'should require an email' do
    @customer.email = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:email], "can't be blank"
  end

  test 'should require a valid email' do
    @customer.email = 'invalid_email'
    assert_not @customer.valid?
    assert_includes @customer.errors[:email], 'is invalid'
  end

  test 'should require a unique email' do
    duplicate_customer = @customer.dup
    @customer.save
    assert_not duplicate_customer.valid?
    assert_includes duplicate_customer.errors[:email], 'has already been taken'
  end

  test 'should require a password' do
    @customer.password = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:password], "can't be blank"
  end

  # Associations
  test 'should have many bookings' do
    assert_respond_to @customer, :bookings
  end

  # Additional Validations
  test 'should require a city' do
    @customer.city = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:city], "can't be blank"
  end

  test 'should require a zip code' do
    @customer.zip_code = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:zip_code], "can't be blank"
  end

  test 'should require a country' do
    @customer.country = nil
    assert_not @customer.valid?
    assert_includes @customer.errors[:country], "can't be blank"
  end
end
