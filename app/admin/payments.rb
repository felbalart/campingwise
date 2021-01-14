ActiveAdmin.register Payment do
  menu priority: 111
  permit_params :order_id, :amount, :payed_at, :payment_method

  form do |f|
    h4 resource&.order&.display_name
    f.inputs do
      f.input :order_id, as: :number
      f.input :amount
      f.input :payed_at
      f.input :payment_method
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :order
    column("Huésped") { |pymnt| pymnt.order.guest }
    column :amount
    column :payed_at
    column('Medio', :payment_method_text)
    column :created_at
    column :updated_at
  end

  controller do
    def build_new_resource
      payment = super
      if action_name == 'new' && params[:order_id]
        order = Order.find params[:order_id]
        payment.order = order
        payment.amount = order.balance_due if order.balance_due > 0
        payment.payed_at = Date.today
      end
      payment
    end

    def scoped_collection
        Payment.includes(order: :guest)
    end
  end

  csv do
    column :id
    column :order_id
    column :amount
    column :payed_at
    column :payment_method
    column :created_at
    column :updated_at
  end
end
