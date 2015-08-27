class Person < ActiveRecord::Base
  has_many :payments, class_name: 'Payment', foreign_key: :creditor_id

  has_many :debtors, through: :creditor_debtor
  has_many :creditor_debtor, class_name: 'Debt', foreign_key: :creditor_id

  def owes(other)
    raise "#{other.class} got when Person expected" unless other.is_a?(Person)

    debt = Debt.of(other, self)
    debt.nil? ? 0 : debt.amount
  end
end
