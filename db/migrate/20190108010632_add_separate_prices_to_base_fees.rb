class AddSeparatePricesToBaseFees < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      remove_column :base_fees, :amount, :decimal
      add_column :base_fees, :total_night_price, :integer
      add_column :base_fees, :adult_price, :integer
      add_column :base_fees, :kid_price, :integer
    end
  end
end
