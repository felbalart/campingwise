class DashboardService < PowerTypes::Service.new(date: Date.today)
  def stats
    Site.category.values.map(&:to_sym).map do |cat|
      stats =
          {
              reserved: reserved_count(cat),
              pending_payment: pending_payment_count(cat),
              available: available_count(cat),
              occupation: occupation(cat)
          }
      [cat, stats]
    end.to_h
  end

  def headers
    [:reserved, :pending_payment, :available, :occupation]
  end

  def human_headers
    ['Reservados', 'Con Deuda', 'Disponibles', 'Ocupación']
  end

  def grouped_reserves
    @grouped_reserves ||=
      Reserve.active.includes(:site, :order).where('start_date <= ?', @date).where('end_date >= ?', @date).group_by { |res| res.site.category.to_sym }
  end

  def reserved_count(category)
    (grouped_reserves[category] || []).map(&:site_id).uniq.count
  end

  def pending_payment_count(category)
    (grouped_reserves[category] || []).map(&:order).uniq.select { |ord| ord.state.unpaid? || ord.state.semi_paid? }.count
  end

  def available_count(category)
     total_sites_count(category) - reserved_count(category)
  end

  def total_sites_count(category)
    Site.where(category: category).count
  end

  def occupation(category)
    total_count = total_sites_count(category)
    return if total_count.zero?
    occ = reserved_count(category).to_f / total_count.to_f
    "#{(occ * 100).round(2)} %"
  end

  def total_occupation
    used_sites = grouped_reserves.values.flatten.map(&:site_id).uniq.count
    total_sites = Site.count
    return if total_sites.zero?
    occ = used_sites.to_f / total_sites.to_f
    "#{(occ * 100).round(2)} %"
  end
end
