class Order < ApplicationRecord
  belongs_to :guest
  has_many :reserves, class_name: 'Reserve'

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
#
# Indexes
#
#  index_orders_on_guest_id  (guest_id)
#
# Foreign Keys
#
#  fk_rails_...  (guest_id => guests.id)
#
