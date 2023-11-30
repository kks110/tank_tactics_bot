class RenameStatsColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :stats, :cities_captures, :cities_captured
    rename_column :stats, :daily_energy_given, :daily_energy_received
  end
end
