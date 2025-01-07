class AddPaymentMethodToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :payment_method_id, :integer
  end
end
