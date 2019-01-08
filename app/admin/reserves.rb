ActiveAdmin.register Reserve do
  menu priority: 109
  permit_params :order_id, :site_id, :start_date, :end_date, :status,
                :adults_qty, :kids_qty, :fix_total_night_price, :adult_price, :kid_price, :total_night_price
end
