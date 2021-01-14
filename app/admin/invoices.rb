ActiveAdmin.register Invoice do
  menu priority: 113
  permit_params :order_id, :category, :number, :amount, :invoiced_at

  form do |f|
    h4 resource&.order&.display_name
    f.inputs do
      f.input :order_id, as: :number
      f.input :category
      f.input :number
      f.input :amount
      f.input :invoiced_at
    end
    f.actions
  end

  index do
    id_column
    column :order
    column("Huésped") { |pymnt| pymnt.order.guest }
    column('Tipo', :category_text)
    column :number
    column :invoiced_at
    column :amount
    column :created_at
    column :updated_at
  end

  controller do
    def build_new_resource
      invoice = super
      if action_name == 'new' && params[:order_id]
        order = Order.find params[:order_id]
        invoice.order = order
        invoice.amount = order.total_amount
        invoice.invoiced_at = Date.today
      end
      invoice
    end

    def scoped_collection
      Invoice.includes(order: :guest)
    end
  end

  csv do
    column :id
    column :order_id
    column :category
    column :number
    column :invoiced_at
    column :amount
    column :created_at
    column :updated_at
  end
end
