class AddInvoicedAtToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :invoiced_at, :date
  end
end
