ActiveAdmin.register_page 'calendar' do
  menu label: 'Calendario', priority: 1

  controller do
    def calendar_service
      @calendar_service ||= CalendarService.new(start_date: start_date)
    end

    def start_date
     @start_date ||= begin
       if params[:date].present?
         Date.strptime(params[:date], '%Y-%m')
       else
         Date.current.beginning_of_month
       end
     end
    end
  end

  content title: proc { "Calendario #{controller.calendar_service.selected_month_text}" } do
    render partial: 'calendar', locals: { service: controller.calendar_service }
  end
end
