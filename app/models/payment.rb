class Payment < ApplicationRecord
  belongs_to :order
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
