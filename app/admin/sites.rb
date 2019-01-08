ActiveAdmin.register Site do
  menu priority: 115
  permit_params :category, :name, :priority
end
