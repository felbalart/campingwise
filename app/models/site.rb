class Site < ApplicationRecord
  extend Enumerize
  enumerize :category, in: [:cabin, :camp_site]

  def full_name
    "#{category_text} - #{name}"
  end
end


# == Schema Information
#
# Table name: sites
#
#  id         :bigint(8)        not null, primary key
#  category   :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
