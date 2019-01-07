ActiveAdmin.register Invoice do
  menu priority: 13
  permit_params :order_id, :category, :number, :amount, :invoiced_at

  controller do
    def build_new_resource
      invoice = super
      if action_name == 'new' && params[:order_id]
        order = Order.find params[:order_id]
        invoice.order = order
        invoice.amount = order.total_amount
      end
      invoice
    end
  end
end
