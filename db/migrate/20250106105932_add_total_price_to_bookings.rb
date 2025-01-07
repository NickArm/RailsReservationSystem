class AddTotalPriceToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :total_price, :decimal
  end
end
