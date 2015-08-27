class CreatePaymentDebtors < ActiveRecord::Migration
  def change
    create_table :payment_debtors do |t|
      t.integer :payment_id
      t.integer :debtor_id

      t.timestamps null: false
    end
    add_index :payment_debtors, :payment_id
  end
end
