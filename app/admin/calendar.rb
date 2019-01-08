ActiveAdmin.register_page "campsites_calendar" do
  menu parent: 'Calendario', label: '1. Sitios Camping', url: '/calendar?sites=campsites'
end

ActiveAdmin.register_page "cdm_calendar" do
  menu parent: 'Calendario', label: '2. CDM', url: '/calendar?sites=cdm'
end

ActiveAdmin.register_page 'calendar' do
  menu false# label: 'Calendario', priority: 1

  controller do
    def calendar_service
      @calendar_service ||= CalendarService.new(start_date: start_date, sites_type: params[:sites].to_sym)
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

    def human_sites_type
      case params[:sites].to_sym
      when :campsites
        'Sitios de Camping'
      when :cdm
        'Instalaciones CDM'
      else
        raise "Unhandled sites type #{@sites_type}"
      end
    end
  end

  content title: proc { "Calendario / #{controller.human_sites_type} / #{controller.calendar_service.selected_month_text}" } do
    render partial: 'calendar', locals: { service: controller.calendar_service }
  end
end
