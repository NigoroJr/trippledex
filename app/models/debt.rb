class Debt < ActiveRecord::Base
  belongs_to :creditor, class_name: 'Person', foreign_key: :creditor_id
  belongs_to :debtor, class_name: 'Person', foreign_key: :debtor_id

  def self.of(creditor, debtor, create = false)
    raise 'Both parameters must be Person' if !creditor.is_a?(Person) || !debtor.is_a?(Person)

    debts = Debt.where(creditor_id: creditor.id, debtor_id: debtor.id)

    unless debts.size <= 1
      raise "Multiple debts with creditor #{creditor.name} and debtor #{debtor.name}"
    end

    if create && debts.first.nil?
      Debt.create({creditor_id: creditor.id, debtor_id: debtor.id})
    else
      debts.first
    end
  end

  def self.update_from_payment(payment)
    raise "#{payment.class} got when expecting Payment" unless payment.is_a?(Payment)

    creditor = payment.creditor
    debtors = payment.debtors
    amount_per_person = payment.amount / debtors.size

    # Look at each person involved in this payment
    debtors.each do |debtor|
      # Change nothing if creditor paid for him/herself
      next if creditor == debtor

      amount_left = amount_per_person

      # First check if `creditor' owes `debtor' some money already
      debt = Debt.of(debtor, creditor)
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

      debt = Debt.of(creditor, debtor) \
             || Debt.new({creditor_id: creditor.id, debtor_id: debtor.id})
      debt.amount += amount_left
      debt.save
    end
  end
end
