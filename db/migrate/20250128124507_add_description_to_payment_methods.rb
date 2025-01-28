class AddDescriptionToPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_methods, :description, :text
  end
end
