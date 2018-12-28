ActiveAdmin.register Invoice do
  permit_params :order_id, :category, :number, :amount
end
