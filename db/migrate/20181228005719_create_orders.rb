class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :guest, foreign_key: true
      t.string :tag

      t.timestamps
    end
  end
end
