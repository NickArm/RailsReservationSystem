class AddReservationSettingsToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :min_days_stay, :integer, default: 1, null: false
    add_column :properties, :max_days_stay, :integer, default: 30, null: false
    add_column :properties, :weekly_discount, :decimal, precision: 5, scale: 2, default: 0.0, null: false
    add_column :properties, :monthly_discount, :decimal, precision: 5, scale: 2, default: 0.0, null: false
  end
end
