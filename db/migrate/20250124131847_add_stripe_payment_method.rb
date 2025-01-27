class AddStripePaymentMethod < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        PaymentMethod.create(name: "Stripe", details: "Online payment via Stripe")
      end
    end
  end
end
