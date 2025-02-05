class AddSmtpSettingsToSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :settings, :smtp_address, :string
    add_column :settings, :smtp_port, :integer
    add_column :settings, :smtp_domain, :string
    add_column :settings, :smtp_user_name, :string
    add_column :settings, :smtp_password, :string
    add_column :settings, :smtp_authentication, :string
    add_column :settings, :smtp_enable_starttls, :boolean
  end
end
