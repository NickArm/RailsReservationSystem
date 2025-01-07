class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :address
      t.references :property, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :guest_count
      t.string :status

      t.timestamps
    end
  end
end
