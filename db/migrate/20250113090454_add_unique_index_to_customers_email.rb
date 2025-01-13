class AddUniqueIndexToCustomersEmail < ActiveRecord::Migration[8.0]
  def change
    add_index "customers", ["email"], name: "index_customers_on_email", unique: true
  end
end
