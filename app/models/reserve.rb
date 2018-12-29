class Reserve < ApplicationRecord
  belongs_to :order
  belongs_to :site
end

# == Schema Information
#
# Table name: reserves
#
#  id              :bigint(8)        not null, primary key
#  order_id        :bigint(8)
#  site_id         :bigint(8)
#  start_date      :date
#  end_date        :date
#  status          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  adults_qty      :integer
#  kids_qty        :integer
#  fix_total_price :boolean
#  adult_price     :integer
#  kid_price       :integer
#  total_price     :integer
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
