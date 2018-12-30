class CalendarService < PowerTypes::Service.new(:start_date)
  attr_accessor :start_date

  SPANISH_MONTH_ABR = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
  def build_month_selector_options
    18.times.map do |month_i|
      date_i = @start_date + (month_i - 6).months
      month_num = date_i.strftime('%m').to_i
      year = date_i.strftime('%Y').to_i
      option_val = "#{year}-#{month_num}"
      m1, m2 = (SPANISH_MONTH_ABR*2)[month_num-1..month_num]
      option_text = if month_num == 12
                      "#{m1} #{year} - #{m2} #{year + 1}"
                    else
                      "#{m1} - #{m2} #{year}"
                    end
      [option_val, option_text]
      end.to_h
  end


end
