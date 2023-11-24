class RemoveAliveFromPlayers < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :alive
  end
end
