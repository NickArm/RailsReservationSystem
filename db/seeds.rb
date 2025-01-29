require 'faker'

# Ensure the existence of an admin
admin = Admin.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password" # Add password confirmation for safety
end

# Create two properties for the admin
property1 = Property.create!(
  name: "Villa Paradise",
  address: "123 Beach St",
  description: "Luxury villa by the sea",
  max_guests: 8,
  admin: admin,
  phone: "123-456-7890",
  country: "Country 1",
  contact_email: "villa.paradise@example.com",
  weekly_discount: 10.0,
  monthly_discount: 20.0
)

property2 = Property.create!(
  name: "Mountain Retreat",
  address: "456 Hilltop Rd",
  description: "Cozy cabin in the mountains",
  max_guests: 6,
  admin: admin,
  phone: "987-654-3210",
  country: "Country 2",
  contact_email: "mountain.retreat@example.com",
  weekly_discount: 15.0,
  monthly_discount: 25.0
)

# Create 5 random customers with passwords
5.times do
  customer = Customer.new(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    address: Faker::Address.full_address,
    country: Faker::Address.country,
    city: Faker::Address.city,
    zip_code: Faker::Address.zip_code,
    password: "password", # Ensure password is provided
    password_confirmation: "password" # Ensure confirmation matches
  )
  if customer.save
    Rails.logger.info "Customer created: #{customer.email}"
  else
    Rails.logger.error "Failed to create customer: #{customer.errors.full_messages.join(', ')}"
  end
end

# Add payment methods, including Stripe
PaymentMethod.find_or_create_by!(name: "Pay on Arrival") do |payment|
  payment.details = "Pay directly to the host upon arrival."
end

PaymentMethod.find_or_create_by!(name: "Bank Transfer") do |payment|
  payment.details = "Transfer the amount to the provided bank account."
end

PaymentMethod.find_or_create_by!(name: "Stripe") do |payment|
  payment.details = "Pay securely using your credit card via Stripe."
end

# Add reservation statuses
["Unpaid", "Confirm Payment", "Paid", "Canceled"].each do |status|
  ReservationStatus.find_or_create_by!(name: status)
end

# Open calendar for both houses from 1/1/2025 to 30/6/2025 with price 150/day
(1..181).each do |day_offset|
  date = Date.new(2025, 1, 1) + day_offset - 1
  [property1, property2].each do |property|
    Calendar.find_or_create_by!(property: property, date: date) do |calendar|
      calendar.status = "open"
      calendar.price = 150.0
    end
  end
end

# Create 2 random bookings for 2 random customers
customers = Customer.limit(2) # Select first 2 customers

customers.each do |customer|
  2.times do
    start_date = Date.new(2025, 1, 1) + rand(0..150)
    end_date = start_date + rand(3..10)

    Booking.create!(
      property: [property1, property2].sample,
      start_date: start_date,
      end_date: end_date,
      guest_count: rand(1..4),
      status: ReservationStatus.find_by(name: "Unpaid").id, # Use ID of "Unpaid" status
      payment_method: PaymentMethod.find_by(name: "Pay on Arrival"),
      customer: customer,
      total_price: (end_date - start_date).to_i * 150.0
    )
  end
end

Rails.logger.info "Seeding completed successfully!"
