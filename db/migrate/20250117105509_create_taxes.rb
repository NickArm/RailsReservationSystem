class CreateTaxes < ActiveRecord::Migration[8.0]
  def change
    create_table :taxes do |t|
      t.string :name
      t.decimal :rate, precision: 8, scale: 2
      t.integer :rate_type, null: false, default: 0 # 0 for flat, 1 for percentage
      t.integer :application_case, null: false, default: 0 # 0 for per guest, 1 for per day, 2 for per booking
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
