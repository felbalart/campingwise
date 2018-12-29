ActiveAdmin.register Order do
  permit_params :guest_id, :tag

  form partial: 'main_form', title: 'Registro Principal'
end
