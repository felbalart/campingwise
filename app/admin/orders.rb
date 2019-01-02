ActiveAdmin.register Order do
  permit_params :guest_id, :tag

  form partial: 'main_form', title: 'Registro Principal'

  controller do
    def create
      create! do |format|
        format.html do
          if @error_message.present?
            flash.now[:error] = @error_message.gsub(';','<br/>').html_safe
            render 'form'
          else
            flash_obj = { notice: 'Orden creada exitosamente!' }
            redirect_to order_path(resource), flash: flash_obj
          end
        end
      end
  end
    def build_new_resource
      if action_name == 'create'
        result = CreateOrder.for(op: params[:order].permit!.to_h)
        if result.is_a?(String)
          @error_message = result
        else # if ok result will be order obj
          return result
        end
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
