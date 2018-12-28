ActiveAdmin.register Payment do
  permit_params :order_id, :amount, :payed_at, :payment_method
end
