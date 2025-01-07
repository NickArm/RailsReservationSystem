# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Admin.create(email: "admin@example.com", password: "password")

property = Property.create(name: "Villa Paradise", address: "123 Beach St", description: "Luxury villa by the sea",
max_guests: 8, admin_id: 1)
Calendar.create(property: property, date: Time.zone.today, status: "open", price: 200.0)

PaymentMethod.create(name: "Pay on Arrival", details: "Pay directly to the host upon arrival.")
PaymentMethod.create(name: "Bank Transfer", details: "Transfer the amount to the provided bank account.")
ReservationStatus.create([ { name: "Unpaid" }, { name: "Confirm Payment" }, { name: "Paid" } ])
rails db: seed
