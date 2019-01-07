class Order < ApplicationRecord
  belongs_to :guest
  has_many :reserves, class_name: 'Reserve'
  has_many :payments
  has_many :invoices
  extend Enumerize
  enumerize :state, in: [:annulled, :unpaid, :semi_paid, :paid, :paid_billed]
  validate :coherent_state

  scope :active, -> { where.not(state: :annulled) }

  def coherent_state
    return if state&.annulled?
    if state != compute_state
      errors.add(state: "State mismatch, it's '#{state}' but should be '#{compute_state}'")
    end
  end

  # udpates state considering associated payments and invoices
  def update_state!
    update(state: compute_state)
  end

  def compute_state
    return :annulled if state&.annulled?
    case paid_amount
    when 0
      return :unpaid
    when 1...total_amount
      return :semi_paid
    when total_amount..99999999999
      return invoices.any? ? :paid_billed : :paid
    end
    raise "Unhandled paid amount #{paid_amount}"
  end

  def date_state
    last_reserve_end = reserves.map(&:end_date).compact.max
    first_reserve_start = reserves.map(&:start_date).compact.min
    return unless last_reserve_end && first_reserve_start
    if last_reserve_end < Date.today
      :past
    elsif first_reserve_start > Date.today
      :future
    else
      :present
    end
  end

  def date_state_text
    {past: 'Pasado', present: 'Presente', future: 'Futuro'}[date_state]
  end

  def total_amount
    reserves.sum(&:total_price)
  end

  def paid_amount
    payments.sum(&:amount)
  end

  def balance_due
    total_amount - paid_amount
  end

  def display_name
    "Orden ##{id} - #{guest.display_name}"
  end
end

# == Schema Information
#
# Table name: orders
#
#  id         :bigint(8)        not null, primary key
#  guest_id   :bigint(8)
#  tag        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string(255)
#
# Indexes
#
#  index_orders_on_guest_id  (guest_id)
#
# Foreign Keys
#
#  fk_rails_...  (guest_id => guests.id)
#
