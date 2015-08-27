class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.integer :creditor_id
      t.integer :debtor_id
      t.float :amount, default: 0

      t.timestamps null: false
    end
    add_index :debts, :creditor_id
  end
end
