class Person < ActiveRecord::Base
  has_many :payments, class_name: 'Payment', foreign_key: :creditor_id

  has_many :debtors, through: :creditor_debtor
  has_many :creditor_debtor, class_name: 'Debt', foreign_key: :creditor_id

  def owes(other)
    raise "#{other.class} got when Person expected" unless other.is_a?(Person)

    debt = Debt.of(other, self)
    debt.nil? ? 0 : debt.amount
  end

  def paid_on_behalf_of!(other, debt_amount)
    amount_left = debt_amount
    # First check if `other' owes us some money already
    debt = Debt.of(other, self)
    if !debt.nil? && debt.amount != 0
      # Owes more than this payment
      if debt.amount > amount_left
        debt.amount -= amount_left
        debt.save
        amount_left = 0
      else
        # Decrease the amount that the `creditor' owes `debtor'
        amount_left -= debt.amount
        debt.amount = 0
        debt.save
      end
    end

    debt = Debt.of(self, other)
    debt = Debt.new({creditor_id: self.id, debtor_id: other.id}) if debt.nil?
    debt.amount += amount_left
    debt.save
  end

  def pay_back!(other, payment_amount)
    other.paid_on_behalf_of!(self, payment_amount)
  end
end
