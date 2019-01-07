ActiveAdmin.register Payment do
  menu priority: 11
  permit_params :order_id, :amount, :payed_at, :payment_method

  controller do
    def build_new_resource
      payment = super
      if action_name == 'new' && params[:order_id]
        order = Order.find params[:order_id]
        payment.order = order
        payment.amount = order.balance_due
        payment.payed_at = Date.today
      end
      payment
    end
  end
end
