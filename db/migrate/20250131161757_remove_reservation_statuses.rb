class RemoveReservationStatuses < ActiveRecord::Migration[8.0]
  def change
    drop_table :reservation_statuses
  end
end
