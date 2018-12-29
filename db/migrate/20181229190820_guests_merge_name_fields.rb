class GuestsMergeNameFields < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      rename_column :guests, :first_name, :name
      remove_column :guests, :last_name
    end
  end
end
