class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :order, foreign_key: true
      t.string :category
      t.string :number
      t.decimal :amount

      t.timestamps
    end
  end
end
