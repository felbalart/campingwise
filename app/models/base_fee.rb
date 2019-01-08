class BaseFee < ApplicationRecord
  extend Enumerize
  enumerize :site_category, in: Site.category.values

  def self.options_for_site_category(category)
    options =
      where(site_category: category).map do |bf|
        [bf.full_name, bf.id]
      end.to_h
    { 'Custom' => :custom }.merge(options)
  end

  def full_name
    "#{site_category_text} - #{fee_name}"
  end
end

# == Schema Information
#
# Table name: base_fees
#
#  id                :bigint(8)        not null, primary key
#  fee_name          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  site_category     :string(255)
#  default_fee       :boolean
#  total_night_price :integer
#  adult_price       :integer
#  kid_price         :integer
#
