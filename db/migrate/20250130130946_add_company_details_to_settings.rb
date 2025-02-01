class AddCompanyDetailsToSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :settings, :company_postcode, :string
    add_column :settings, :company_email, :string
    add_column :settings, :notifications_email, :string
  end
end
