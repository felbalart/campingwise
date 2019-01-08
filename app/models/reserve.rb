class Reserve < ApplicationRecord
  belongs_to :order
  belongs_to :site
  delegate :guest, to: :order

  scope :active, -> { includes(:order).where.not(orders: { state: :annulled}) }

  # TODO validate avoid >=2 reserves same site same dates


  validate :price_logic
  validate :ends_after_start
  validates :total_night_price, presence: true

  def price_logic
    if fix_total_night_price
      errors.add(:adult_price, 'no puede existir si se escoje fijar precio total') if adult_price.present?
      errors.add(:kid_price, 'no puede existir si se escoje fijar precio total') if kid_price.present?
    else
      expected_total = (adults_qty.to_i * adult_price.to_i) + (kids_qty.to_i * kid_price.to_i)
      errors.add(:total_night_price, 'no calza con cantidades y precios estipulados') unless total_night_price == expected_total
    end
  end

  def ends_after_start
    return unless start_date && end_date
    if end_date < start_date
      errors.add(:end_date, "'Fecha Hasta' no puede ser anterior a 'Fecha Desde'")
    end
  end

  def nights_long
    return unless start_date && end_date
    (end_date - start_date).to_i + 1
  end

  def total_final_price
    total_night_price * nights_long.to_i
  end

  def status
    order&.state_text
  end
end

# == Schema Information
#
# Table name: reserves
#
#  id                    :bigint(8)        not null, primary key
#  order_id              :bigint(8)
#  site_id               :bigint(8)
#  start_date            :date
#  end_date              :date
#  status                :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  adults_qty            :integer
#  kids_qty              :integer
#  fix_total_night_price :boolean
#  adult_price           :integer
#  kid_price             :integer
#  total_night_price     :integer
#
# Indexes
#
#  index_reserves_on_order_id  (order_id)
#  index_reserves_on_site_id   (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (site_id => sites.id)
#
