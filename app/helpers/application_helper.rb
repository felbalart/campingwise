module ApplicationHelper

  def translate_date(date)
    return unless date
    day = translate_day date.strftime('%A')
    rest = date.strftime('%d/%m/%Y')
    "#{day}, #{rest}"
  end

  def translate_day(english_day)
    case english_day.downcase
    when 'monday'
      'lunes'
    when 'tuesday'
      'martes'
    when 'wednesday'
      'miércoles'
    when 'thursday'
      'jueves'
    when 'friday'
      'viernes'
    when 'saturday'
      'sábado'
    when 'sunday'
      'domingo'
    end
  end
end
