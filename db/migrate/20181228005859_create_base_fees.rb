class CreateBaseFees < ActiveRecord::Migration[5.2]
  def change
    create_table :base_fees do |t|
      t.string :fee_name
      t.decimal :amount

      t.timestamps
    end
  end
end
