ActiveAdmin.register Reserve do
  menu priority: 9
  permit_params :order_id, :site_id, :start_date, :end_date, :status,
                :adults_qty, :kids_qty, :fix_total_price, :adult_price, :kid_price, :total_price
end
