class AddDetailsToProperties < ActiveRecord::Migration[8.0]
  def change
    add_column :properties, :phone, :string
    add_column :properties, :country, :string
    add_column :properties, :contact_email, :string
  end
end
