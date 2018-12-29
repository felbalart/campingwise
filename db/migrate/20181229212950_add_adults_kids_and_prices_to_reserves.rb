class AddAdultsKidsAndPricesToReserves < ActiveRecord::Migration[5.2]
  def change
    add_column :reserves, :adults_qty, :integer
    add_column :reserves, :kids_qty, :integer
    add_column :reserves, :fix_total_price, :boolean
    add_column :reserves, :adult_price, :integer
    add_column :reserves, :kid_price, :integer
    add_column :reserves, :total_price, :integer
  end
end
