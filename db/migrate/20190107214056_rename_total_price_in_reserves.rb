class RenameTotalPriceInReserves < ActiveRecord::Migration[5.2]
  def up
    safety_assured do
      rename_column :reserves, :total_price, :total_night_price
      rename_column :reserves, :fix_total_price, :fix_total_night_price
    end
  end

  def down
    safety_assured do
      rename_column :reserves, :total_night_price, :total_price
      rename_column :reserves, :fix_total_night_price, :fix_total_price
    end
  end
end
