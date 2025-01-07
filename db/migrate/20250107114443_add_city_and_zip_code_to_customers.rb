class AddCityAndZipCodeToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :city, :string
    add_column :customers, :zip_code, :string
  end
end
