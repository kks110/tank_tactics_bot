class RemoveColumnsFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :fog_of_war
    remove_column :games, :cities
  end
end
