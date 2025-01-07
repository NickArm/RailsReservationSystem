class ChangeStatusToIntegerInBookings < ActiveRecord::Migration[7.0]
  def up
    # Change existing string column to integer with a default value
    change_column :bookings, :status, :integer, using: 'status::integer', default: 0, null: false
  end

  def down
    # Revert back to string in case of rollback
    change_column :bookings, :status, :string
  end
end
