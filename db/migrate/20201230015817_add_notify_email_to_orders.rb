class AddNotifyEmailToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :notify_email, :boolean
  end
end
