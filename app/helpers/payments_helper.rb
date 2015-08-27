module PaymentsHelper
  def actual_debtors(payment)
    debtors = payment.debtors
    debtors = debtors.select { |p| p != payment.creditor }
    debtors.map { |d| d.name }
  end
end
