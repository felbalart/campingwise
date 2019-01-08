class BaseFee < ApplicationRecord
  extend Enumerize
  enumerize :site_category, in: Site.category.values
  validate :category_values_logic
  validates_presence_of :site_category, :fee_name

  def self.options_for_site_category(category)
    options =
      where(site_category: category).map do |bf|
        [bf.full_name, bf.id]
      end.to_h
    { 'Custom' => :custom }.merge(options)
  end

  def category_values_logic
    return unless site_category.present?
    if site_category.campsite?
      errors.add(:total_night_price, 'no debe definirse para tarifas de sitios de camping') if total_night_price.present?
      errors.add(:adult_price, 'debe definirse para tarifas de sitios de camping') if adult_price.blank?
      errors.add(:kid_price, 'debe definirse para tarifas de sitios de camping') if kid_price.blank?
    else
      errors.add(:total_night_price, 'debe definirse (excepto tarifas de sitios de camping)') if total_night_price.blank?
      errors.add(:adult_price, 'no debe definirse (excepto tarifas de sitios de camping)') if adult_price.present?
      errors.add(:kid_price, 'no debe definirse (excepto tarifas de sitios de camping)') if kid_price.present?
    end
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
