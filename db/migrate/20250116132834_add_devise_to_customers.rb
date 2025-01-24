class AddDeviseToCustomers < ActiveRecord::Migration[8.0]
  def change
    # Devise required fields
    add_column :customers, :encrypted_password, :string, null: false, default: ""
    add_column :customers, :reset_password_token, :string
    add_column :customers, :reset_password_sent_at, :datetime
    add_column :customers, :remember_created_at, :datetime

    # Add indexes for Devise fields
    add_index :customers, :reset_password_token, unique: true
  end
end
