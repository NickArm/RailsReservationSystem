class CreateEnabledPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :enabled_payment_methods do |t|
      t.references :admin, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps
    end
  end
end
