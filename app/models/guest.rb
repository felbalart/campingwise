class Guest < ApplicationRecord
  def display_name
    full_name
  end

  def full_name
    "#{first_name} #{last_name} (#{email})"
  end
end

# == Schema Information
#
# Table name: guests
#
#  id         :bigint(8)        not null, primary key
#  email      :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
