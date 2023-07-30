class AddFogOfWarToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :fog_of_war, :boolean
  end
end
