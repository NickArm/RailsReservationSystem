class AddUniqueCodeToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :unique_code, :string, null: true
    add_index :bookings, :unique_code, unique: true
  end
end
