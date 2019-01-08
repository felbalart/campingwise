ActiveAdmin.register Invoice do
  menu priority: 113
  permit_params :order_id, :category, :number, :amount, :invoiced_at

  controller do
    def build_new_resource
      invoice = super
      if action_name == 'new' && params[:order_id]
        order = Order.find params[:order_id]
        invoice.order = order
        invoice.amount = order.total_amount
        invoice.invoiced_at = Date.today
      end
      invoice
    end
  end

  csv do
    column :id
    column :order_id
    column :category
    column :number
    column :invoiced_at
    column :amount
    column :created_at
    column :updated_at
  end
end
