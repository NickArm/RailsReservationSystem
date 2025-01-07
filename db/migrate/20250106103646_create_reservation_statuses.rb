class CreateReservationStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
