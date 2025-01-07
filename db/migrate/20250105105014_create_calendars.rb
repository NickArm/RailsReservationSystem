class CreateCalendars < ActiveRecord::Migration[8.0]
  def change
    create_table :calendars do |t|
      t.references :property, null: false, foreign_key: true
      t.date :date
      t.string :status
      t.decimal :price

      t.timestamps
    end
  end
end
