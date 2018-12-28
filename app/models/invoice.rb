class Invoice < ApplicationRecord
  belongs_to :order
end

# == Schema Information
#
# Table name: invoices
#
#  id         :bigint(8)        not null, primary key
#  order_id   :bigint(8)
#  category   :string(255)
#  number     :string(255)
#  amount     :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_invoices_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
