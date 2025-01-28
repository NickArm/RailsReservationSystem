class EnabledPaymentMethod < ApplicationRecord
  belongs_to :admin
  belongs_to :payment_method
end
