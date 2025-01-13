class AddUniqueIndexToCalendarsDateAndPropertyId < ActiveRecord::Migration[8.0]
  def change
    add_index :calendars, [:date, :property_id], unique: true
  end
end
