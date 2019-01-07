class Invoice < ApplicationRecord
  belongs_to :order
  extend Enumerize
  enumerize :category, in: [:person_bill, :commercial_invoice]
  validates_presence_of :order_id, :category, :number, :amount
  validates_uniqueness_of :number
  after_save :update_order_state
  after_destroy :update_order_state

  def update_order_state
    order.update_state!
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id          :bigint(8)        not null, primary key
#  order_id    :bigint(8)
#  category    :string(255)
#  number      :string(255)
#  amount      :decimal(10, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  invoiced_at :date
#
# Indexes
#
#  index_invoices_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
