class Payment < ApplicationRecord
  belongs_to :order
  extend Enumerize
  enumerize :payment_method, in: [:credit_card, :debit_card, :cash, :transfer]

  validates_presence_of :order_id, :amount, :payed_at, :payment_method
  after_save :update_order_state
  after_destroy :update_order_state

  def update_order_state
    order.update_state!
  end
end

# == Schema Information
#
# Table name: payments
#
#  id             :bigint(8)        not null, primary key
#  order_id       :bigint(8)
#  amount         :decimal(10, )
#  payed_at       :date
#  payment_method :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_payments_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
