class CreateGlobalStats < ActiveRecord::Migration[7.0]
  def change
    create_table :global_stats do |t|
      t.bigint :player_discord_id, null: false
      t.text :username, null: false
      t.integer :kills, default: 0
      t.integer :deaths, default: 0
      t.integer :cities_captured, default: 0
      t.integer :cities_lost, default: 0
      t.integer :most_cities_held, default: 0
      t.integer :energy_spent, default: 0
      t.integer :energy_given, default: 0
      t.integer :energy_received, default: 0
      t.integer :daily_energy_received, default: 0
      t.integer :hp_given, default: 0
      t.integer :hp_received, default: 0
      t.integer :highest_energy, default: 0
      t.integer :highest_hp, default: 0
      t.integer :highest_range, default: 0
      t.integer :times_moved, default: 0
      t.integer :energy_cells_collected, default: 0
      t.integer :damage_done, default: 0
      t.integer :damage_received, default: 0
    end
  end
end
