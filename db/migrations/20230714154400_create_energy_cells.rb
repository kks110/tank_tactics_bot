class CreateEnergyCells < ActiveRecord::Migration[7.0]
  def change
    create_table :energy_cells do |t|
      t.integer :x_position
      t.integer :y_position
    end
  end
end
