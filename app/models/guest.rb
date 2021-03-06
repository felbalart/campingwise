class Guest < ApplicationRecord
  has_many :orders
  validates :name, presence: true
  validates :email,  uniqueness: true, presence: true


  def display_name
    "#{name} (#{email})"
  end
end

# == Schema Information
#
# Table name: guests
#
#  id         :bigint(8)        not null, primary key
#  email      :string(255)
#  name       :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
