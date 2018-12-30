ActiveAdmin.register_page 'calendar ', title: 'aa' do
  content do
    puts 'florin111'
    puts params

    @start_date = if params[:date].present?
                    Date.strptime(params[:date], '%Y-%m')
                  else
                    Date.current.beginning_of_month
                  end
    render partial: 'calendar', locals: { service: CalendarService.new(start_date: @start_date) }
  end
end
