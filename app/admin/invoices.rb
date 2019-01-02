ActiveAdmin.register Invoice do
  menu priority: 13
  permit_params :order_id, :category, :number, :amount
end
