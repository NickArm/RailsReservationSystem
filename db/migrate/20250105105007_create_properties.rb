class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :address
      t.text :description
      t.integer :max_guests
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
