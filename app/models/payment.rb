class Payment < ActiveRecord::Base
  belongs_to :creditor, class_name: 'Person', foreign_key: :creditor_id

  has_many :debtors, through: :payment_debtor
  has_many :payment_debtor, class_name: 'PaymentDebtor', foreign_key: :payment_id
end
