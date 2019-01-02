class Order < ApplicationRecord
  belongs_to :guest
  has_many :reserves, class_name: 'Reserve'
  # validate :valid_guest, :at_least_one_reserve, :valid_reserves
  #
  # def valid_guest
  #   return if guest&.valid?
  #   errors.add(:base, 'Huésped con errores')
  # end
  #
  # def at_least_one_reserve
  #   errors.add(:base, 'Orden debe tener al menos una reserva') if reserves.empty?
  # end
  #
  # def valid_reserves
  #   errors = reserves.map do |res|
  #     res.valid?
  #     res.errors.full_messages
  #   end.flatten
  #   errors.add(:base, 'Orden tiene reservas con errores') unless errors.empty?
  # end



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
