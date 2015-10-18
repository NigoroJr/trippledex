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

      creditor.paid_on_behalf_of!(debtor, amount_per_person)

      amount_left = amount_per_person
    end
  end

  def self.undo(payment)
    creditor = payment.creditor
    debtors = payment.debtors
    refund_per_person = payment.amount / debtors.size

    debtors.each do |debtor|
      creditor.pay_back!(debtor, refund_per_person)
    end
  end
end
