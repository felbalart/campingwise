ActiveAdmin.register Site do
  menu priority: 15
  permit_params :category, :name, :priority
end
