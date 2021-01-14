ActiveAdmin.register Reserve do
  menu priority: 109
  permit_params :order_id, :site_id, :start_date, :end_date, :status,
                :adults_qty, :kids_qty, :fix_total_night_price, :adult_price, :kid_price, :total_night_price

  controller do
    def scoped_collection
      Reserve.includes(:order, :site)
    end
  end
  csv do
    column(:guest_id) { |res| res.order&.guest&.id }
    column(:guest_name) { |res| res.order&.guest&.name }
    column(:order_id) { |res| res.order.id }
    column(:order_tag) { |res| res.order.tag }
    column(:order_state) { |res| res.order.state }
    column(:reserve_id) { |res| res.id }
    column(:site_id)
    column(:site_category) { |res| res.site&.category }
    column(:site_name) { |res| res.site&.name }
    column(:start_date)
    column(:nights_long)
    column(:end_date)
    column(:adults_qty)
    column(:kids_qty)
    column(:fix_total_night_price)
    column(:adult_price)
    column(:kid_price)
    column(:total_night_price)
    column(:total_final_price)
    column(:created_at)
    column(:updated_at)
  end
end
