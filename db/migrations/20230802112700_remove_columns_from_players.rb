class RemoveColumnsFromPlayers < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :kills
    remove_column :players, :deaths
    remove_column :players, :city_captures
  end
end
