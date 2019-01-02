ActiveAdmin.register Payment do
  menu priority: 11
  permit_params :order_id, :amount, :payed_at, :payment_method
end
