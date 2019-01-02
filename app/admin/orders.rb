ActiveAdmin.register Order do
  permit_params :guest_id, :tag

  form partial: 'main_form', title: proc { resource.id.present? ? "Orden ##{resource.id}" : 'Registrar Nueva Orden' }

  controller do
    def create
      super do
        flash.now[:error] = @error_message.gsub(';', '<br/>').html_safe if @error_message.present?
      end
    end

    def update
      super do
        flash.now[:error] = @error_message.gsub(';', '<br/>').html_safe if @error_message.present?
      end
    end

    def create_or_update
      result = ProcessOrder.for(op: params[:order].permit!.to_h.merge(id: params[:id]))
      resource = result[:order]
      @error_message = result[:errors_msg]
      if @error_message.present?
        flash_obj = { error: @error_message.gsub(';', " - ") }
        destination = action_name == 'create' ?  new_order_path : edit_order_path(resource)
        redirect_to destination, flash: flash_obj
      else
        flash_obj = { notice: "Orden #{action_name == 'create' ? 'creada' : 'actualizada'} exitosamente!" }
        redirect_to order_path(resource), flash: flash_obj
      end
    end

    def update_resource(object, _rp)
      result = ProcessOrder.for(op: params[:order].permit!.to_h.merge(id: params[:id]), order: object)
      @error_message = result[:errors_msg]
      @error_message.blank?
    end

    def build_new_resource
      if action_name == 'create'
        result = ProcessOrder.for(op: params[:order].permit!.to_h)
        order = result[:order]
        @error_message = result[:errors_msg]
        order.errors.add(:base, @error_message) if @error_message.present?
        return order
      end
      if action_name == 'new'
        order = super
        reserve = Reserve.new
        reserve.start_date = params[:start_date].present? ? params[:start_date].to_date : Date.today
        reserve.end_date = reserve.start_date + 1.day
        reserve.site_id = params[:site_id].to_i if params[:site_id].present?
        order.reserves << reserve
        return order
      end
      super
    end
  end
end
