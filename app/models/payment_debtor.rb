class PaymentDebtor < ActiveRecord::Base
  belongs_to :payment, class_name: 'Payment', foreign_key: :payment_id
  belongs_to :debtor, class_name: 'Person', foreign_key: :debtor_id
end
