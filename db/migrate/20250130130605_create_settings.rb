class CreateSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :settings do |t|
      t.string :company_name
      t.string :registration_number
      t.string :phone
      t.string :address
      t.string :city
      t.string :logo
      t.string :language
      t.string :currency

      t.timestamps
    end
  end
end
