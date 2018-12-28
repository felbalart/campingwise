class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :order, foreign_key: true
      t.decimal :amount
      t.date :payed_at
      t.string :payment_method

      t.timestamps
    end
  end
end
