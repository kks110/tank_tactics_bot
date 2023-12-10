class AddGamesPlayedToGlobalStats < ActiveRecord::Migration[7.0]
  def change
    add_column :global_stats, :games_played, :integer, default: 0
  end
end
