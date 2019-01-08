class Site < ApplicationRecord
  extend Enumerize
  enumerize :category, in: [:campsite, :family_cabin, :suite_cabin, :family_dome, :small_dome, :motorhome]
  validates :priority, numericality: { greater_than_or_equal_to: 0 }

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
#  priority   :integer          default(999999)
#
