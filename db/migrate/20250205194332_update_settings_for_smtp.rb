class UpdateSettingsForSmtp < ActiveRecord::Migration[8.0]
  def change
    change_table :settings, bulk: true do |t|
      t.string :smtp_authentication, default: "plain", null: false unless column_exists?(:settings, :smtp_authentication)
      t.boolean :smtp_enable_starttls, default: true, null: false unless column_exists?(:settings, :smtp_enable_starttls)
      t.boolean :ssl, default: false, null: false unless column_exists?(:settings, :ssl) # Add the `ssl` column if not present
    end
  end
end
