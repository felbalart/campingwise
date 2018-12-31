class CalendarService < PowerTypes::Service.new(:start_date)
  attr_accessor :start_date

  SPANISH_MONTH_ABR = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
  SPANISH_DAY_INITIALS = ['L', 'M', 'W', 'J', 'V', 'S', 'D']
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

  def grouped_reserves
    @grouped_reserves ||= begin
      res = Reserve.where('start_date >= ?', @start_date)
              .where('end_date < ?', @start_date + 2.months)
              .includes(order: :guest)
      res.group_by(&:site_id)
    end
  end

  def grouped_days
    @grouped_days ||= begin
      gdays = (start_date.beginning_of_week..end_date).each_slice(7).to_a
      week1 = gdays.first
      week1 = week1[week1.index(start_date)..-1] # remove previous month's days
      gdays[0] = week1
      gdays
    end
  end

  SITE_GROUP_SIZE = 5
  def grouped_sites
    @grouped_sites ||= begin
      Site.all.each_slice(SITE_GROUP_SIZE).to_a
    end
  end

  def reserves_for_cell(site_id, day)
    return [] unless grouped_reserves.keys.include?(site_id)
    grouped_reserves[site_id].select do |res|
      res.start_date <= day && res.end_date >= day
    end
  end

  def end_date
    @start_date + 2.months - 1.day
  end
end
