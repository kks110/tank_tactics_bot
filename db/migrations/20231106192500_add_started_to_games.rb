class AddStartedToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :started, :boolean, default: false
  end
end
