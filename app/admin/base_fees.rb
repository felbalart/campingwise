ActiveAdmin.register BaseFee do
  menu priority: 117
  permit_params :fee_name, :site_category, :default_fee, :adult_price, :kid_price, :total_night_price
end
