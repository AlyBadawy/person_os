class AddActiveToEventable < ActiveRecord::Migration[8.1]
  def change
    add_column :eventables, :active, :boolean, default: true, null: false
  end
end
