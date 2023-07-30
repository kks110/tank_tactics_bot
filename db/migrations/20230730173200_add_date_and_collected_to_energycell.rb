class AddDateAndCollectedToEnergycell < ActiveRecord::Migration[7.0]
  def change
    add_column :energy_cells, :created_at, :datetime
    add_column :energy_cells, :collected, :boolean, default: false
  end
end
