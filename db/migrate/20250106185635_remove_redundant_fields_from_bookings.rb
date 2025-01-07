class RemoveRedundantFieldsFromBookings < ActiveRecord::Migration[8.0]
  def change
    remove_column :bookings, :name, :string
    remove_column :bookings, :email, :string
    remove_column :bookings, :phone, :string
    remove_column :bookings, :address, :text
  end
end
