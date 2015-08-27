class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :name, null: false
      t.float :amount, null: false
      t.timestamp :date

      t.integer :creditor_id, null: false

      t.timestamps null: false
    end
  end
end
