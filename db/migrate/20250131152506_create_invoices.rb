class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :invoice_number
      t.decimal :total_amount
      t.decimal :tax_amount
      t.integer :payment_status
      t.datetime :issued_date
      t.datetime :due_date
      t.datetime :paid_date
      t.text :notes
      t.string :vat_number

      t.timestamps
    end
  end
end
