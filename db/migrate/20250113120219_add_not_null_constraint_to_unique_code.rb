class AddNotNullConstraintToUniqueCode < ActiveRecord::Migration[8.0]
  def change
    change_column_null :bookings, :unique_code, false
  end
end
