ActiveAdmin.register Reserve do
  permit_params :order_id, :site_id, :start_date, :end_date, :status
end
