ActiveAdmin.register Order do
  menu priority: 5
  permit_params :guest_id, :tag

  actions :all, except: [:destroy]

  form partial: 'main_form', title: 'Registrar Nueva Orden'

  show { render partial: 'show' }

  controller do
    def create(options={}, &block)
      object = build_resource
      if @error_message.blank?
        options[:location] ||= smart_resource_url
      else
        object.errors.add(:base, @error_message)
        flash.now[:error] = "Errores:;#{@error_message}".gsub(';','<br/>').html_safe
      end
      respond_with_dual_blocks(object, options, &block)
    end

    def update(options={}, &block)
      object = resource
      result = ProcessOrder.for(op: params[:order].permit!.to_h, order: object)
      @error_message = result[:errors_msg]
      if @error_message.blank?
        options[:location] ||= smart_resource_url
      else
        object.errors.add(:base, @error_message)
        flash.now[:error] = "Errores:;#{@error_message}".gsub(';','<br/>').html_safe
      end
      respond_with_dual_blocks(object, options, &block)
    end

    def build_new_resource
      if action_name == 'create'
        result = ProcessOrder.for(op: params[:order].permit!.to_h)
        order = result[:order]
        @error_message = result[:errors_msg]
        return order
      end
      if action_name == 'new'
        order = super
        reserve = Reserve.new
        reserve.site_id = params[:site_id] if params[:site_id].present?
        reserve.start_date = params[:start_date].present? ? params[:start_date].to_date : Date.today
        reserve.end_date = reserve.start_date + 1.day
        reserve.site_id = params[:site_id].to_i if params[:site_id].present?
        order.reserves << reserve
        return order
      end
      super
    end
  end

  member_action :annul, method: :put do
    resource.update(state: :annulled)
    redirect_to resource_path, notice: 'La orden fue anulada'
  end

  action_item :annul, only: :show  do
    link_to 'Anular Orden', { action: :annul }, method: :put, data: { confirm: 'Está seguro que desea anular la orden?' }
  end

  action_item :add_payment, only: :show  do
    link_to 'Agregar Pago', new_payment_path(order_id: resource.id)
  end

  action_item :add_invoice, only: :show  do
    link_to 'Agregar Boleta', new_invoice_path(order_id: resource.id)
  end
end
