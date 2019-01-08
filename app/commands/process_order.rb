class ProcessOrder < PowerTypes::Command.new(:op, order: Order.new(state: :unpaid))
  def perform
    guest = guest_from_params
    guest.validate
    # order = order_from_params
    order = @order
    order.tag = @op[:tag]
    order.guest = guest
    order.state = order.compute_state
    order.validate
    reserves_hash = reserves_from_params
    reserves_hash.values.each do |res|
      res.order = order
      res.validate
    end
    errors_hash = reserves_hash.map { |k, res| ["Reserva #{k}", error_messages(res)] }.to_h
    errors_hash.merge!('Huésped' => error_messages(guest), 'Orden' => error_messages(order))
    errors_hash.compact!
    errors_str = nil
    if errors_hash.any?
      errors_str = errors_hash.map { |k, v| "#{k}: #{v}"}.join(';').delete('[]"')
    else # everything ok
      order.reserves = reserves_hash.values
      order.state = order.compute_state
      guest.save!
      order.save!
      reserves_hash.values.each { |ores| ores.order_id = order.id  }
      reserves_hash.values.each(&:save!)
    end
    { order: order, errors_msg: errors_str }
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

  # DEPRECATED
  def order_from_params
    order =
      if @op[:id].present?
        Order.find(@op[:id])
      else
        Order.new
      end
    order.tag = @op[:tag] if @op[:tag].present?
    order
  end

  def reserves_from_params
    @op.map do |k, v|
      next unless k.to_s.starts_with?('reserve')
      next if k == 'reserve0' # hidden mold
      [k.remove('reserve').to_i, build_or_fetch_reserve(v)]
    end.compact.to_h
  end

  def build_or_fetch_reserve(data)
    reserve = if data[:id].present?
                Reserve.find(data[:id])
              else
                Reserve.new
              end
    reserve.assign_attributes(
      site_id: data[:site_id],
      start_date: parse_date(data[:start_date]),
      end_date: parse_date(data[:end_date]),
      adults_qty: data[:adults_qty],
      kids_qty: data[:kids_qty],
      fix_total_night_price: parse_boolean(data[:fix_total_night_price]),
      adult_price: data[:adult_price],
      kid_price: data[:kid_price],
      total_night_price: data[:total_night_price]
    )
    reserve
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
