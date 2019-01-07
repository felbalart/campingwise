ActiveAdmin.register BaseFee do
  menu priority: 17
  permit_params :fee_name, :amount, :site_category, :default_fee
end
