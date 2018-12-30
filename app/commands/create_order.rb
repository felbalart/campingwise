class CreateOrder < PowerTypes::Command.new(:op)
  def perform

    guest = guest_from_params
    guest.validate
    order = order_from_params
    order.guest = guest
    order.validate
    reserves_hash = reserves_from_params
    reserves_hash.values.each do |res|
      res.order = order
      res.validate
    end
    errors_hash = reserves_hash.map { |k, res| ["Reserva #{k}", error_messages(res)] }.to_h
    errors_hash.merge!('Huésped' => error_messages(guest), 'Orden' => error_messages(order))
    errors_hash.compact!
    binding.pry
    if errors_hash.any?
      errors_str = errors_hash.map { |k, v| "#{k}: #{v}"}.join(';').delete('[]"')
      return "Error: #{errors_str}"
    end
    guest.save!
    order.save!
    reserves_hash.values.each(&:save!)
    order
  end

  def guest_from_params
    guest =
      if @op[:guest_id].present? && @op[:guest_id].to_i > 0
        Guest.find(@op[:guest_id])
      else
        Guest.new
      end
    guest.assign_attributes(name: @op[:guest][:name], email: @op[:guest][:email], phone: @op[:guest][:phone])
    guest
  end

  def order_from_params
    Order.new(tag: @op[:tag])
  end

  def reserves_from_params
    @op.map do |k, v|
      next unless k.to_s.starts_with?('reserve')
      next if k == 'reserve0' # hidden mold
      [k.remove('reserve').to_i, build_reserve(v)]
    end.compact.to_h
  end

  def build_reserve(data)
    Reserve.new(
      site_id: data[:site_id],
      start_date: parse_date(data[:start_date]),
      end_date: parse_date(data[:end_date]),
      adults_qty: data[:adults_qty],
      kids_qty: data[:kids_qty],
      fix_total_price: parse_boolean(data[:fix_total_price]),
      adult_price: data[:adult_price],
      kid_price: data[:kid_price],
      total_price: data[:total_price]
    )
  end

  def parse_boolean(value)
    value.in? ['true', true, 1, '1']
  end

  def parse_date(str)
    return if str.blank?
    Date.strptime(str, '%d/%m/%Y')
  end

  def error_messages(obj)
    return if obj.valid?
    obj.errors.full_messages
  end
end
