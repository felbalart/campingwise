class AddPriorityToSites < ActiveRecord::Migration[5.2]
  def up
    add_column :sites, :priority, :integer
    change_column_default :sites, :priority, 999999
  end

  def down
    remove_column :sites, :priority
  end
end
