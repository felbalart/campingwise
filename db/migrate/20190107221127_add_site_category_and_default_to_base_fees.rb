class AddSiteCategoryAndDefaultToBaseFees < ActiveRecord::Migration[5.2]
  def change
    add_column :base_fees, :site_category, :string
    add_column :base_fees, :default_fee, :boolean
  end
end
